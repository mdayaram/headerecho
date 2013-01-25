#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'

helpers do
  def request_headers
    env.inject({}){|acc, (k,v)| acc[$1.downcase] = v if k =~ /^http_(.*)/i; acc}
  end  
end

get '*' do
  r = "Request Headers:<br/><br/><br/>"
  request_headers.each do |k, v|
    r += "#{k} => #{v}<br/>"
  end
  return r
end
