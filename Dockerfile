FROM ruby:2.4

USER root

# Go is for interacting with Google Drive
ENV GOROOT /go
ENV GOPATH /go/packages
ENV GO_FILE "go1.9.3.linux-amd64.tar.gz"
RUN \
  mkdir -p $GOROOT && mkdir -p $GOPATH && \
  wget https://dl.google.com/go/$GO_FILE && \
  tar -C / -xzf $GO_FILE

ENV PATH $GOROOT/bin:$GOPATH/bin:$PATH

RUN go get github.com/prasmussen/gdrive


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
