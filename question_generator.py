import streamlit as st
import random
from retrieve_data import connect_to_mysql, get_unanswered_questions, get_answered_questions, update_question_status
from ai_hint import chat_with_gpt

def main():
	st.title("Interview Question Generator")

	# Connect to MySQL
	conn = connect_to_mysql()
	if conn is None:
		return

	# Display answered questions in a table
	with st.expander("View Answered Questions"):
		answered_questions = get_answered_questions(conn)
		if answered_questions:
			page_size = st.number_input("Page size", min_value=1, value=10, step=5)
			total_pages = (len(answered_questions) + page_size - 1) // page_size
			page_number = st.number_input("Page number", min_value=1, max_value=total_pages, step=1)

			start_idx = (page_number - 1) * page_size
			end_idx = start_idx + page_size
			st.dataframe(answered_questions[start_idx:end_idx])
		else:
			st.info("No answered questions found.")

	# Dropdowns for type and priority filters
	question_types = ["Java Core", "Java 8", "Design Patterns", "JDBC, Hibernate, Database",
					"Spring", "Microservices", "Optional - JavaScript", "Optional - Angular",
					"Optional - React", "Unknown"]
	attention = ["Newly added", "Important", "Normal"]

	selected_type = st.selectbox("Select question type:", ["All"] + question_types)
	selected_priority = st.selectbox("Select question attention:", ["All"] + attention)

	# Checkbox for prioritization filter
	show_prioritized = st.checkbox("Prioritized questions")

	# Convert 'All' to None for SQL query compatibility
	selected_type = None if selected_type == "All" else selected_type
	selected_priority = None if selected_priority == "All" else selected_priority

	if st.button("Get Random Unanswered Question"):
		with st.spinner("Fetching unanswered questions..."):
			questions = get_unanswered_questions(conn, selected_type, selected_priority, show_prioritized)

		if questions:
			# Choose a random question
			random_question = random.choice(questions)
			st.session_state.random_question = random_question
			st.rerun()
		else:
			st.info("No unanswered questions found for the selected filters.")

	if 'random_question' in st.session_state:
		random_question = st.session_state.random_question

		st.markdown(f"""
					<div style='padding: 10px; border: 2px solid #4CAF50; border-radius: 5px; background-color: #050505;'>
						<h3 style='text-align: left;'> {random_question['question']}</h3><br>
						<strong style='text-align: left;'>Type:</strong> <span style='text-align: left;'>{random_question['type']}</span><br>
						<strong style='text-align: left;'>Attention:</strong> <span style='text-align: left;'>{random_question['attention']}</span>
					</div>
					""", unsafe_allow_html=True)

		if st.button("Get Hint"):
			hint = chat_with_gpt(random_question['question'])
			st.write(f"**Hint:** {hint}")

		if st.button("Mark as Answered"):
			update_question_status(conn, random_question['id'])
			del st.session_state.random_question  # Reset the random_question in session state
			st.rerun()

	# Close the database connection
	conn.close()

if __name__ == "__main__":
	main()
