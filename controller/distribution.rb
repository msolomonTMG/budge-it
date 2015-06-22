
# ROUTES 

get '/distributions' do
	@accounts = Account.all
	@envelopes = Envelope.all
	@distributions = Distribution.all
	@deleted = params['deleted']
	erb :distributions
end

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

# FUNCTIONS

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
	distribution = Distribution.get(distribution_id)
	success = distribution.destroy
	if success == true
		return true
	else
		return false
	end
end