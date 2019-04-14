FROM ruby:2.4-stretch

ENV APP_HOME /app \
    COMMENT_DATABASE_HOST comment_db \
    COMMENT_DATABASE comments

RUN apt-get update -qq && apt-get install -y build-essential --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir $APP_HOME

WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/
COPY . $APP_HOME
RUN bundle install

CMD ["puma"]

