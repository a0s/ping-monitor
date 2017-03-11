FROM ruby:2.3-alpine
MAINTAINER anton.osenenko@gmail.com
ENV LANG C.UTF-8

RUN apk add --update --no-cache \
    bash \
    git \
    curl \
    build-base \
    postgresql-dev

WORKDIR /opt/pingmonitor

COPY Gemfile Gemfile.lock /opt/pingmonitor/
RUN bundle install --deployment

COPY config.ru Rakefile /opt/pingmonitor/
COPY app /opt/pingmonitor/app
COPY bin /opt/pingmonitor/bin
COPY config /opt/pingmonitor/config
COPY db /opt/pingmonitor/db
COPY lib /opt/pingmonitor/lib
