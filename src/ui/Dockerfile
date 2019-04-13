FROM ruby:2.4-stretch

ENV APP_HOME /app \
    POST_SERVICE_HOST post \
    POST_SERVICE_PORT 5000 \
    COMMENT_SERVICE_HOST comment \
    COMMENT_SERVICE_PORT 9292

RUN apt-get update -qq && apt-get install -y build-essential --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir $APP_HOME

WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/
RUN bundle install
COPY . $APP_HOME

CMD ["puma"]
