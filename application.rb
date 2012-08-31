require 'rubygems'
require 'sinatra'
require 'haml'
require 'pp'

require File.expand_path('../rt.rb', __FILE__)

get '/new-q/:queue' do
  card_wall_controller = CardWallController.new
  card_wall_controller.show(params)
end

get '/q/:queue' do
  rt = RT::Server.new
  tickets = RT::Query.new(rt)
  @queue = params[:queue]

  results = tickets.where('Queue').is(@queue).execute

  @cards = Hash.new
  # @statuses = [ 'new', 'open', 'stalled', 'resolved', 'rejected', 'deleted' ]
  @statuses = [ 'new', 'open', 'stalled', 'resolved' ]

  @statuses.each do |status|
    @cards[status] = results.select { |t| t['Status'] == status }
  end

  haml :card_wall
end

class CardWallController
  def show(params)

    rt = RT::Server.new
    tickets = RT::Query.new(rt)
    @queue = params[:queue]

    results = tickets.where('Queue').is(@queue).execute


    @cards = Hash.new
    @statuses = [ 'new', 'open', 'stalled', 'resolved' ]

    @statuses.each do |status|
      @cards[status] = results.select { |t| t['Status'] == status }
    end

    haml :card_wall
  end

  def haml( template_id )
    layout = File.read('views/layout.haml')
    template = File.read('views/' + template_id.to_s + '.haml')
    layout_engine = Haml::Engine.new(layout)
    layout_engine.render(self) do
      template_engine = Haml::Engine.new(template)
      template_engine.render(self)
    end
  end
end

class CardWallModel
end
