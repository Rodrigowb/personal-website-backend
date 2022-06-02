# CONFIG 1 
# Define base image and maintainer
FROM python:3.9-alpine3.13
LABEL maintainer='app.rodwanderley.com'

ENV PYTHONBUFFERED 1

# Copy the requirements, define work dir. and local port
COPY ./requirements.txt /tmp/requirements.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Install depndencies in the image and create a docker venv
RUN python -m venv /py && \
  /py/bin/pip install --upgrade pip && \
  /py/bin/pip install -r /tmp/requirements.txt && \
  rm -rf /tmp && \
  adduser \
  --disabled-password \
  --no-create-home \
  django-user

# Update env variable inside the image
ENV PATH="/py/bin:$PATH"

# Specify the used user
USER django-user
