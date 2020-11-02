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
  tzdata

# use "virtual" group for rails testing dependencies
# - tree for dir listing
# - xvfb for headless browser
ARG env
RUN if [ "$env" = "development" ]; then \
  apk add --no-cache --update --virtual rails-test-dependencies \
  tree \
  xvfb \
  ; fi

RUN gem install bundler
RUN gem install rake

COPY Gemfile* /tmp/
WORKDIR /tmp
# This sets initial cached install,
#   We `bundle install` again, via docker-compose.yml ($app/bin/start_ci),
#   to ensure gems are updated outside of cache
# RUN bundle install --jobs 4 --retry 3 --without=development
RUN bundle install --jobs 4 --retry 3


# Remove build dependencies which are no longer needed
# RUN apk del build-dependencies

# Setup app dir
ENV app /app
RUN mkdir $app
WORKDIR $app

ADD . $app

# Security: lock down to "nobody" user
# 201804: remove this security step.  We couldn't upgrade gems during docker run.
# RUN chown -R nobody:nogroup /app
# USER nobody

# Optimize gem usage via shared volume
# see: https://medium.com/@fbzga/how-to-cache-bundle-install-with-docker-7bed453a5800
# ISSUE: permission denied for bin/start_ci
#ENV BUNDLE_PATH /gem_volume

# Configure for CI
# RUN chmod +x $app/bin/start_ci
# ENV RAILS_ENV ci

EXPOSE 3000
# moved command to docker-compose.yml
CMD ["bundle", "exec", "rails", "s"]
