import mysql.connector
import streamlit as st
import os
from dotenv import load_dotenv
import random

# Load environment variables from .env file
load_dotenv()

def connect_to_mysql():
	try:
		conn = mysql.connector.connect(
			host=os.getenv('HOST'),
			user=os.getenv('USER'),
			password=os.getenv('PASSWORD'),
			database=os.getenv('DB')
		)
		# st.success("Connected to MySQL database")
		return conn
	except Exception as e:
		st.error(f"Error connecting to MySQL: {e}")
		return None

def get_unanswered_questions(conn, selected_type=None, selected_priority=None):
	cursor = conn.cursor(dictionary=True)

	# Build the SQL query based on filter choices
	query = "SELECT id, question, type, priority FROM questions WHERE is_answered = FALSE"
	params = []
	if selected_type:
		query += " AND type = %s"
		params.append(selected_type)
	if selected_priority:
		query += " AND priority = %s"
		params.append(selected_priority)

	cursor.execute(query, params)
	questions = cursor.fetchall()
	cursor.close()
	return questions

def get_answered_questions(conn):
	cursor = conn.cursor(dictionary=True)
	cursor.execute("SELECT question, type, priority FROM questions WHERE is_answered = TRUE")
	answered_questions = cursor.fetchall()
	cursor.close()
	return answered_questions

def update_question_status(conn, question_id):
	try:
		cursor = conn.cursor()
		cursor.execute("UPDATE questions SET is_answered = TRUE WHERE id = %s", (question_id,))
		conn.commit()
		cursor.close()
	except Exception as e:
		st.error(f"Error updating question status: {e}")

def main():
	st.title("Interview Question Generator")

	# Connect to MySQL
	conn = connect_to_mysql()
	if conn is None:
		return

	# Display answered questions in a table
	# st.subheader("Answered Questions")
	with st.expander("View Answered Questions"):
		answered_questions = get_answered_questions(conn)
		# Pagination for answered questions
		if answered_questions:
			page_size = st.number_input("Page size", min_value=1, value=10, step=5)
			total_pages = (len(answered_questions) + page_size - 1) // page_size
			page_number = st.number_input("Page number", min_value=1, max_value=total_pages, step=1)

			start_idx = (page_number - 1) * page_size
			end_idx = start_idx + page_size
			st.dataframe(answered_questions[start_idx:end_idx])
		else:
			st.info("No answered questions found.")

	# st.subheader("Unanswered Questions")

	# Dropdowns for type and priority filters
	question_types = ["Java Core", "Java 8", "Design Patterns", "JDBC, Hibernate, Database",
					  "Spring", "Microservices", "Optional - JavaScript", "Optional - Angular",
					  "Optional - React", "Unknown"]
	priorities = ["Newly added", "Prioritized", "Often asked", "No priority"]

	selected_type = st.selectbox("Select question type:", ["All"] + question_types)
	selected_priority = st.selectbox("Select question priority:", ["All"] + priorities)

	# Convert 'All' to None for SQL query compatibility
	selected_type = None if selected_type == "All" else selected_type
	selected_priority = None if selected_priority == "All" else selected_priority

	if 'random_question' not in st.session_state:
		if st.button("Get Random Unanswered Question"):
			questions = get_unanswered_questions(conn, selected_type, selected_priority)

			if questions:
				# Choose a random question
				random_question = random.choice(questions)
				st.session_state.random_question = random_question
				st.rerun()
			else:
				st.info("No unanswered questions found for the selected filters.")
	else:
		random_question = st.session_state.random_question

		st.markdown(f"<div style='padding: 10px; border: 2px solid #4CAF50; border-radius: 5px; background-color: #050505;'>"
						f"<h3><strong>Question:</strong> {random_question['question']}</h3><br>"
						f"<strong>Type:</strong> {random_question['type']}<br>"
						f"<strong>Priority:</strong> {random_question['priority']}</div>",
						unsafe_allow_html=True)

		if st.button("Mark as Answered"):
			update_question_status(conn, random_question['id'])
			del st.session_state.random_question  # Reset the random_question in session state
			st.rerun()

	# Close the database connection
	conn.close()

if __name__ == "__main__":
	main()
