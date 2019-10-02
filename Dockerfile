FROM ruby:2.6.5

WORKDIR /app

ARG RAILS_ENV=development
ENV RAILS_ENV=$RAILS_ENV

COPY Gemfile /app
COPY Gemfile.lock /app
RUN bundle install --jobs=4

COPY . /app
