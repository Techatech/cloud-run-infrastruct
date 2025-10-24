# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONUNBUFFERED True
ENV APP_HOME /app
WORKDIR $APP_HOME

# Install system dependencies (if any, e.g., for libraries)
# RUN apt-get update && apt-get install -y --no-install-recommends some-package && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY ./app ./app
COPY main.py .
# COPY run.py . # We don't need run.py in the container anymore
# COPY ingest.py . # Optional: include if needed for some reason
# COPY app/ascii_diagrammer.py ./app/ # Make sure custom modules are copied

# Expose the port the app runs on (default Gunicorn port is 8000, Cloud Run uses 8080)
EXPOSE 8080

# Define the command to run the application using Gunicorn
# Gunicorn runs the 'app' variable within the 'main.py' file
# Use the Uvicorn worker for FastAPI compatibility
# Bind to 0.0.0.0 and the port Cloud Run expects ($PORT or default 8080)
CMD exec gunicorn --bind :$PORT --workers 1 --worker-class uvicorn.workers.UvicornWorker --threads 8 main:app