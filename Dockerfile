FROM ruby:2.7.1

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=4

COPY config.ru .session.key ./

EXPOSE 4000
CMD ["rackup", "config.ru", "-o", "0.0.0.0", "-p", "4000", "-q"]
