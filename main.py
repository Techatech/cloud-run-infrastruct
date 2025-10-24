import os
import google.generativeai as genai
from dotenv import load_dotenv
from google.adk.cli.fast_api import get_fast_api_app # Import for getting the app

# Import your root_agent (ensure app/agent.py is correct)
from app.agent import root_agent

# Load environment variables early
load_dotenv()

# Configure Gemini API key (needed if not using Vertex AI)
api_key = os.getenv("GEMINI_API_KEY")
if api_key:
    try:
        genai.configure(api_key=api_key)
        print("Gemini API key configured.")
    except Exception as e:
        print(f"Error configuring Gemini API key: {e}")
else:
    print("GEMINI_API_KEY not found. Assuming Vertex AI or other auth.")

# Get the FastAPI app instance from ADK, passing your root agent
# The agent_name 'app' matches the default used by adk web
agent_directory = "." 
app = get_fast_api_app(agents_dir=agent_directory, web=True)
print("FastAPI app created successfully.")

# Gunicorn will run this 'app' object. No need to run uvicorn here.
# If running locally for testing: uvicorn main:app --host 0.0.0.0 --port 8080