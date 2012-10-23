require 'rubygems'
require 'perftools'

require File.expand_path('../rt.rb', __FILE__)


PerfTools::CpuProfiler.start("rtlib_profile") do
  10.times do |i|
    puts "Iteration ##{i}"

    rt = RT::Server.new
    tickets = RT::Query.new(rt)
    @queue = "automation"
    results = tickets.where('Queue').is(@queue).execute

  end
end
