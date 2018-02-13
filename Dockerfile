FROM golang:1.7.3 as go

FROM ruby:2.4
# Set environment variables.
RUN mkdir -p /goroot && mkdir -p /gopath

ENV GOROOT /goroot
ENV GOPATH /gopath
ENV PATH $GOROOT/bin:$GOPATH/bin:$PATH
COPY --from=go /gopath /gopath
COPY --from=go /goroot /goroot

RUN go get github.com/prasmussen/gdrive

USER root

# Install postgres so we can restore from backups using pg_restore
RUN \
  echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
  apt-get update && \
  apt-get -y install postgresql postgresql-contrib nodejs

RUN mkdir /web

WORKDIR /web

ENV BUNDLE_PATH=vendor/bundle
ENV BUNDLE_DISABLE_SHARED_GEMS=1

COPY Gemfile /web/Gemfile
COPY Gemfile.lock /web/Gemfile.lock
COPY vendor /web/vendor
RUN bundle install --path /web/vendor/bundle

COPY . /web

#CMD bundle exec rails s -p 3000
