# Author: Mike Solomon
# This app is to manage a budget via the envelope method
# 

require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'json'
require 'rest-client'

#require models
Dir[File.dirname(__FILE__) + '/model/*.rb'].each {|file| require file }

#require controllers
Dir[File.dirname(__FILE__) + '/controller/*.rb'].each {|file| require file }

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/my.db")

DataMapper.auto_upgrade!

post '/distribution/create' do
	distribution = params[:distribution]
	distribution = create_distribution distribution['account'], distribution['envelope'], distribution['amount'].to_f
	redirect '/'
end

post '/distribution/delete' do
	distribution = params[:distribution]
	success = delete_distribution distribution['id']
	if success == true
		redirect '/distributions?deleted=true'
	else
		redirect '/distributions?deleted=false'
	end
end

post '/allocation/create' do
	allocation = params[:allocation]
	allocation = create_allocation allocation['source'], allocation['account'], allocation['amount'].to_f
	redirect '/'
end

post '/allocation/delete' do
	allocation_id = params[:allocation_id]
	success = delete_allocation allocation_id
	redirect '/'
end

post '/source/create' do
	source = params[:source]
	source = create_source source['name'], source['amount'].to_f
	redirect '/'
end

post '/account/create' do
	account = params[:account]
	account = create_account account['name']
	redirect "/#account#{account['id']}"
end

post '/envelope/create' do
	envelope = params[:envelope]
	envelope = create_envelope envelope['name'], envelope['balance'].to_f
	redirect "/#envelope#{envelope['id']}"
end

get '/distributions' do
	@accounts = Account.all
	@envelopes = Envelope.all
	@distributions = Distribution.all
	@deleted = params['deleted']
	erb :distributions
end

get '/' do
	@envelopes = Envelope.all(:order => [:name.asc])
	@accounts = Account.all(:order => [:name.asc])
	@sources = Source.all(:order => [:name.asc])
	@allocations = Allocation.all
	@distributions = Distribution.all
	erb :index#, :locals => {:envelopes => envelopes}
end

get '/sources' do
	@envelopes = Envelope.all(:order => [:name.asc])
	@accounts = Account.all(:order => [:name.asc])
	@sources = Source.all(:order => [:name.asc])
	@allocations = Allocation.all
	@distributions = Distribution.all
	erb :sources#, :locals => {:envelopes => envelopes}
end

get '/dashboard' do
	envelopes = Envelope.all(:order => [:name.asc])
	accounts = Account.all(:order => [:name.asc])
	sources = Source.all(:order => [:name.asc])
	allocations = Allocation.all
	distributions = Distribution.all
	
	@data = Hash.new
	@data["envelopes"] = envelopes
	@data["accounts"] = accounts
	@data["sources"] = sources
	@data["allocations"] = allocations
	@data["distributions"] = distributions

	erb :dashboard
end

get '/test' do
	envelopes = Envelope.all(:order => [:name.asc])
	accounts = Account.all(:order => [:name.asc])
	sources = Source.all(:order => [:name.asc])
	allocations = Allocation.all
	distributions = Distribution.all
	
	@data = Hash.new
	@data["envelopes"] = envelopes
	@data["accounts"] = accounts
	@data["sources"] = sources
	@data["allocations"] = allocations
	@data["distributions"] = distributions

	erb :test
end

get '/accounts' do
	@accounts = Account.all
	erb :accounts
end

get '/envelopes' do
	@envelopes = Envelope.all
	i = 0
	while i < @envelopes.length do
		i += 1
	end
end

get '/api/accounts' do
	@accounts = Account.all(:envelopes => Envelope.all(:accounts => @account))
	#comments.to_json(:relationships=>{:user=>{:include=>[:first_name],:methods=>[:age]}})
	
	content_type :json
		{ :accounts => @accounts}.to_json
end





