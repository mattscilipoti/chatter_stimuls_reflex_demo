# startup services & web server for docker

# start redis, without persistence, as background process
redis-server  --save "" --appendonly no &

# Stimulus Reflex requires caching to be enabled. Caching allows the session to be modified during ActionCable requests.
cache_dev_config_file=./tmp/caching-dev.txt
# -r: Return true value, if file exists and is readable
if test ! -r "$cache_dev_config_file"; then
  bundle exec rails dev:cache
fi

# start rails server,
# - use binding 0.0.0.0 for visibility from host browser
bundle exec rails server --binding 0.0.0.0
