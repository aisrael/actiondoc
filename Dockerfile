FROM ruby:2.7.1-alpine

ENV RUBYLIB='lib'

RUN apk update && apk add --no-cache git build-base && mkdir -p /actiondoc

COPY . .
RUN gem build && gem install actiondoc-0.1.0.gem

WORKDIR /src

ENTRYPOINT [ "actiondoc" ]
