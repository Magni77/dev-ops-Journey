FROM python:3.9.5-slim

ENV APP_DIR=/code

WORKDIR $APP_DIR

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY build ./build

RUN pip install -r ./build/requirements.txt

COPY . .
