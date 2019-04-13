FROM python:3.6.0-alpine

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

RUN apk update && \
    apk add --virtual build-dependencies build-base gcc

WORKDIR /app
COPY . /app

RUN pip install --upgrade pip && \
    pip install -r /app/requirements.txt

ENTRYPOINT ["python3", "post_app.py"]
