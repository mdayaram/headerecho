#!/usr/bin/env ruby

PORT = 4567
if ARGV.length > 0
  PORT = ARGV[0].to_i
  if PORT == 0
    PORT = 4567
  end
end
