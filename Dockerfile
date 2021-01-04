FROM ruby:2.7.2-alpine
LABEL maintainer=matt@scilipoti.name
# re: http://blog.kontena.io/rails-5-and-docker/

RUN apk update
RUN apk upgrade

# use "virtual" group for build dependencies
# build-base is alpine equivalent of build-essential
RUN apk add --virtual build-dependencies \
  build-base \
  git

# use "virtual" group for rails dependencies
# - curl for remote health checks
# - nodejs for assets
# - postgresql-dev to compile 'pg' gem
# - postgresql-client for psql command
# - tzdata for timezones
RUN apk add --no-cache --virtual rails-run-dependencies \
  curl \
  nodejs \
  redis \
  sqlite \
  sqlite-dev \
  tzdata \
  yarn

# use "virtual" group for rails testing dependencies
# - openssh: connect to git repo
# - tree for dir listing
# - xvfb for headless browser
ARG env
RUN apk add --no-cache --update --virtual rails-test-dependencies \
  openssh
# tree \
# xvfb \

# Size Optimization: add rails dependencies separately from code
RUN gem install bundler
RUN gem install rake

COPY Gemfile* /tmp/
WORKDIR /tmp
# This sets initial cached install,
RUN bundle install --jobs 4 --retry 3

# install yarn dependencies
COPY package.json yarn.lock ./
RUN yarn install --pure-lockfile

# Remove build dependencies which are no longer needed
# RUN apk del build-dependencies

# Setup app dir
ENV app /app
RUN mkdir $app
WORKDIR $app

ADD . $app

# Optimize gem usage via shared volume
# see: https://medium.com/@fbzga/how-to-cache-bundle-install-with-docker-7bed453a5800
# ISSUE: permission denied for bin/start_ci
#ENV BUNDLE_PATH /gem_volume

EXPOSE 3000
CMD bin/startup.sh
