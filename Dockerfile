FROM ruby:3.2.2-alpine

ENV RUBYLIB='lib'

COPY pkg/actiondoc-0.3.0.gem .
RUN gem install actiondoc-0.3.0.gem && rm actiondoc-0.3.0.gem

WORKDIR /src

ENTRYPOINT [ "actiondoc" ]
