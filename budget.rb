# Author: Mike Solomon
# This app uses some terrible programming practices to flip Jira statuses
# based on GitHub labels on corresponding pull requests
# 

require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'json'
require 'rest-client'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/my.db")#"sqlite::memory:")

#Acccounts are collections of envelopes
#Sources have amounts that are allocated to accounts
#Amounts get deposited into each envelope according to a number
class Account
	include DataMapper::Resource

	property :id, Serial
	property :name, String

	has n, :allocations, :required => false
	has n, :sources, :through => :allocations

	has n, :distributions, :required => false
	has n, :envelopes, :through => :distributions
end

#Envelopes are objects that host balances
#Envelopes receive their balances through the distribution of account allocations
class Envelope
	include DataMapper::Resource

	property :id, Serial
	property :name, String
	property :balance, Float

	has n, :distributions, :required => false
	has n, :accounts, :through => :distributions
end

#Income sources are deposited into accounts through allocations
class Source
	include DataMapper::Resource

	property :id, Serial
	property :name, String
	property :amount, Float

	has n, :allocations, :required => false
	has n, :accounts, :through => :allocations
end

#Allocations are relationships between income sources and accounts
class Allocation
	include DataMapper::Resource

	property :id, Serial
	property :amount, Float

	belongs_to :account#,	:key => true
	belongs_to :source#, 	:key => true

end

#just like Sources are Allocated to Accounts
#Envelopes are populated by the Distribution of the Account (accounts are funded by source allocation)
class Distribution
	include DataMapper::Resource

	property :id, Serial
	property :amount, Float

	belongs_to :account#,	:key => true
	belongs_to :envelope#, 	:key => true
end

#DataMapper.finalize
DataMapper.auto_upgrade!
=begin
Account.auto_migrate!
Envelope.auto_migrate!
Source.auto_migrate!
Allocation.auto_migrate!
Distribution.auto_migrate!
=end

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
	puts account
	account = create_account account['name']
	redirect "/#account#{account['id']}"
end

post '/envelope/create' do
	envelope = params[:envelope]
	puts envelope
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

	puts "JSON"
	puts @data.to_json
	puts "HASH"
	puts @data
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
		puts @envelopes[i].account.to_json
		i += 1
	end
end

get '/api/accounts' do
	@accounts = Account.all(:envelopes => Envelope.all(:accounts => @account))
	#comments.to_json(:relationships=>{:user=>{:include=>[:first_name],:methods=>[:age]}})
	
	content_type :json
		{ :accounts => @accounts}.to_json
end

def create_account (name)
	account = Account.create(
		:name => name
	)
end

def create_envelope (name, balance)
	envelope = Envelope.create(
		:name => name,
		:balance => balance
	)
end

def create_source (name, amount)
	source = Source.create(
		:name => name,
		:amount => amount
	)
end

def create_allocation (source, account, amount)
	allocation = Allocation.create(
		:source_id => source,
		:account_id => account,
		:amount => amount
	)
end

def delete_allocation (allocation_id)
	allocation = Allocation.get(allocation_id)
	success = allocation.destroy
	if success == true
		return true
	else
		return false
	end
end

def create_distribution (account, envelope, amount)
	distribution = Distribution.create(
		:account_id => account,
		:envelope_id => envelope,
		:amount => amount
	)
end

def update_distribution (id, account, envelope, amount)
	distribution = Distribution.get(id)
	distribution.update(
		:account_id => account,
		:envelope_id => envelope,
		:amount => amount
	)
end

def delete_distribution (distribution_id)
	puts distribution_id
	distribution = Distribution.get(distribution_id)
	puts distribution
	success = distribution.destroy
	if success == true
		return true
	else
		return false
	end
end

def delete_envelope (name)
	#if user != nil && action != nil
	envelope = Envelope.first(:name => name)
	envelope.name = name
	envelope.destroy
end
