FROM ruby:2.7.1-alpine

ENV RUBYLIB='lib'

RUN apk update && apk add --no-cache git build-base

COPY . .
RUN bundle install --without development

ENTRYPOINT [ "actiondoc" ]
