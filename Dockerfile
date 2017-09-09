FROM ruby:2.4.1-alpine

ENV PROJECT_DIR=/usr/src/app/

RUN apk add --no-cache build-base sqlite sqlite-dev

WORKDIR $PROJECT_DIR

COPY Gemfile Gemfile.lock $PROJECT_DIR

ENV BUNDLE_PATH=/gem

RUN bundle install -j 2

COPY . $PROJECT_DIR

EXPOSE 3000

ENTRYPOINT [ "./entrypoint" ]

CMD [ "run" ]
