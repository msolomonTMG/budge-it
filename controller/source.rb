# ROUTES 

get '/sources' do
	@envelopes = Envelope.all(:order => [:name.asc])
	@accounts = Account.all(:order => [:name.asc])
	@sources = Source.all(:order => [:name.asc])
	@allocations = Allocation.all
	@distributions = Distribution.all
	erb :sources#, :locals => {:envelopes => envelopes}
end

post '/source/create' do
	source = params[:source]
	source = create_source source['name'], source['amount'].to_f
	redirect '/'
end

# FUNCTIONS

def create_source (name, amount)
	source = Source.create(
		:name => name,
		:amount => amount
	)
end