require 'rubygems'
require 'sinatra'
require 'haml'
require 'pp'
require 'ruby-prof'
require File.expand_path('../rt.rb', __FILE__)

get '/q/:queue' do
  # RubyProf.start
  rt = RT::Server.new
  tickets = RT::Query.new(rt)
  @queue = params[:queue]
  # pp queue
  results = tickets.where('Queue').is(@queue).execute
  # pp results

  @cards = Hash.new
  # @statuses = [ 'new', 'open', 'stalled', 'resolved', 'rejected', 'deleted' ]
  @statuses = [ 'new', 'open', 'stalled', 'resolved' ]

  @statuses.each do |status|
    @cards[status] = results.select { |t| t['Status'] == status }
  end

  # pp @cards
  
  # result = RubyProf.stop

  # printer = RubyProf::GraphHtmlPrinter.new(result)
  # File.open('profile.log', 'w') do |f|
  #   printer.print(f)
  # end
  haml :card_wall
end
