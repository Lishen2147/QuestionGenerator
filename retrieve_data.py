import mysql.connector
import streamlit as st
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

def connect_to_mysql():
	try:
		conn = mysql.connector.connect(
			host='localhost',
			user=os.getenv('MYSQL_USER'),
			password=os.getenv('MYSQL_PASSWORD'),
			database=os.getenv('MYSQL_DB'),
		)
		return conn
	except Exception as e:
		st.error(f"Error connecting to MySQL: {e}")
		return None

def get_unanswered_questions(conn, selected_type=None, selected_priority=None, show_prioritized=False):
	cursor = conn.cursor(dictionary=True)

	# Build the SQL query based on filter choices
	query = "SELECT id, question, type, attention FROM questions WHERE is_answered = FALSE"
	params = []
	if selected_type:
		query += " AND type = %s"
		params.append(selected_type)
	if selected_priority:
		query += " AND attention = %s"
		params.append(selected_priority)
	if show_prioritized:
		query += " AND is_prioritized = TRUE"  # Filter for prioritized questions

	cursor.execute(query, params)
	questions = cursor.fetchall()
	cursor.close()
	return questions

def get_answered_questions(conn):
	cursor = conn.cursor(dictionary=True)
	cursor.execute("SELECT question, type, attention FROM questions WHERE is_answered = TRUE")
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