# CONFIG 1 
# Define base image and maintainer
FROM python:3.9-alpine3.13
LABEL maintainer='app.rodwanderley.com'

ENV PYTHONBUFFERED 1

# Copy the requirements, define work dir. and local port
COPY ./requirements.txt /tmp/requirements.txt
# CONFIG 2
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# END 2
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# CONFIG 2
ARG DEV=false
# END 2
# Install depndencies in the image and create a docker venv
RUN python -m venv /py && \
  /py/bin/pip install --upgrade pip && \
  # CONFIG 3
  # Dependencies to install psycopgs
  apk add --update --no-cache postgresql-client && \
  apk add --update --no-cache --virtual .tmp-build-deps \
  build-base postgresql-dev musl-dev && \
  # END 3
  /py/bin/pip install -r /tmp/requirements.txt && \
  # CONFIG 2
  if [ $DEV = "true" ]; \
  then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
  fi && \
  # END 2
  rm -rf /tmp && \
  # CONFIG 3
  # Keep dockerfile lightweight
  apk del .tmp-build-deps && \
  # END 3
  adduser \
  --disabled-password \
  --no-create-home \
  django-user

# Update env variable inside the image
ENV PATH="/py/bin:$PATH"

# Specify the used user
USER django-user
