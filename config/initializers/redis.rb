$redis = Redis::Namespace.new("orange-blog", :redis => Redis.new)

# connect to the server and store that connection as a global resource