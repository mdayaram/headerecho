#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'

helpers do
  def request_headers
    not_headers = ["version"]
    env.inject({}) do |acc, (k,v)|
      if k =~ /^http_(.*)/i and !not_headers.include?($1.downcase)
        acc[$1.downcase] = v
      end
      acc
    end
  end  
end

# Define a handler for multiple http verbs at once
def any(url, verbs = %w(get post put delete), &block)
  verbs.each do |verb|
    send(verb, url, &block)
  end
end

any '*' do
  path = request.path
  if !request.query_string.nil? or !request.query_string.empty?
    path += "?#{request.query_string}"
  end

  r = "#{request.request_method.upcase} #{path} #{env["HTTP_VERSION"].upcase}\r\n"
  request_headers.each do |k, v|
    r += "#{k.capitalize}: #{v}\r\n"
  end
  return "<pre>#{r}</pre>"
end
