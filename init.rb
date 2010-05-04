$: << "lib/"
require 'rubygems'
require 'sdb_service'


SERV = SdbService::Service.new("caring-syslog-test")
puts "ready."