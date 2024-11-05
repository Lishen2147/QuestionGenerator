from openai import OpenAI
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Function to interact with ChatGPT
def chat_with_gpt(question):
    # Set your OpenAI API key
    client = OpenAI(
        api_key=os.getenv('OPENAI_API_KEY')
	)
    prompt = f"Given me a hint on this question: {question}\n"

    try:
        # Send a message to ChatGPT
        response = client.chat.completions.create(
			messages=[
				{
					"role": "user",
					"content": "Say this is a test",
				}
			],
			model="gpt-3.5-turbo",
		)

        # Extract the response text
        message = response.choices[0].message['content']  # Accessing via the correct attribute
        return message.strip()

    except Exception as e:
        return f"An error occurred: {str(e)}"