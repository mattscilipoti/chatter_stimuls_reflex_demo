# startup services & web server for docker

# start redis, without persistence, as background process
redis-server  --save "" --appendonly no &

# start rails server,
# - use binding 0.0.0.0 for visibility from host browser
bundle exec rails server --binding 0.0.0.0
