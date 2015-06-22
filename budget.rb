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

get '/' do
	@envelopes = Envelope.all(:order => [:name.asc])
	@accounts = Account.all(:order => [:name.asc])
	@sources = Source.all(:order => [:name.asc])
	@allocations = Allocation.all
	@distributions = Distribution.all
	erb :index#, :locals => {:envelopes => envelopes}
end

get '/test2' do
	@envelopes = Envelope.all(:order => [:name.asc])
	@accounts = Account.all(:order => [:name.asc])
	@sources = Source.all(:order => [:name.asc])
	@allocations = Allocation.all
	@distributions = Distribution.all
	erb :test_data_table
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






