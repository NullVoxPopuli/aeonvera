FROM ruby:2.4.1

USER root

# Install postgres so we can restore from backups using pg_restore
RUN \
  echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
  apt-get update && \
  apt-get -y install postgresql postgresql-contrib nodejs

RUN mkdir /web

WORKDIR /web

ADD Gemfile /web/Gemfile
ADD Gemfile.lock /web/Gemfile.lock
RUN bundle install

ADD . /web

#CMD bundle exec rails s -p 3000
