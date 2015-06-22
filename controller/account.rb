
# ROUTES 

get '/accounts' do
	@accounts = Account.all
	erb :accounts
end

get '/api/accounts' do
	@accounts = Account.all(:envelopes => Envelope.all(:accounts => @account))
	#comments.to_json(:relationships=>{:user=>{:include=>[:first_name],:methods=>[:age]}})
	
	content_type :json
		{ :accounts => @accounts}.to_json
end

post '/account/create' do
	account = params[:account]
	account = create_account account['name']
	redirect "/#account#{account['id']}"
end

# FUNCTIONS

def create_account (name)
	account = Account.create(
		:name => name
	)
end