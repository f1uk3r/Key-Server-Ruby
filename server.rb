require 'sinatra'
require_relative 'key_server'

server_functions = KeyServer.new
get '/' do
  'Welcome to Key Server API'
end

get '/add/:count' do |count|
  begin
    status 200
    server_functions.generate_keys(Integer(count))
  rescue ArgumentError => e
    status 404
    "Count is not Integer"
  end
end

get '/available-key' do
  key = server_functions.get_available_key
  puts "yahan pahuncha kya?1"
  if key
    status 200
    key
  else
    status 404
    "No available keys"
  end
end

get '/unblock-key/:key' do |key|
  required_key = server_functions.unblock_key(key)
  if required_key
    status 200
    required_key
  else
    status 404
    "No such key are blocked"
  end
end

get '/delete-key/:key' do |key|
  deleted_key = server_functions.delete_key(key)
  if deleted_key
    status 200
    deleted_key
  else
    status 404
    "No such keys exist"
  end
end

get '/stayin-alive/:key' do |key|
  alive_key = server_functions.stayin_alive(key)
  if alive_key
    status 200
    alive_key
  else
    status 404
    "No such keys exist"
  end
end

get '/status' do
  server_functions.keys.to_s
end