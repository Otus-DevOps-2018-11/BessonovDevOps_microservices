#FROM ruby:2.4-stretch
FROM ruby:2.4.2-stretch

ENV APP_HOME /app
ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292

RUN apt-get update -qq && apt-get install -y build-essential --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir $APP_HOME

WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/
COPY . $APP_HOME
RUN bundle install

CMD ["puma"]

