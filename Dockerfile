FROM ruby:2.4

RUN apt-get update && apt-get install -y libidn11-dev

WORKDIR /app

COPY Gemfile /app
COPY Gemfile.lock /app
RUN if [ "${RAILS_ENV}" = "development" ] || [ "${RAILS_ENV}" = "test" ]; then \
    bundle install --jobs 4; \
  else \
    bundle install --jobs 4 --without development test; \
  fi

COPY . /app
RUN bundle exec rake assets:precompile
