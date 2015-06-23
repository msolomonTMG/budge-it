
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

post '/account/delete' do
	account = params[:account]
	success = delete_account account['id']
	if success == true
		redirect '/accounts?deleted=true'
	else
		redirect '/accounts?deleted=false'
	end
end

# FUNCTIONS

def create_account (name)
	account = Account.create(
		:name => name
	)
end

def delete_account (account_id)
	account = Account.get(account_id)
	distributions = Distribution.all(:account_id => account_id)
	allocations = Allocation.all(:account_id => account_id)
	puts allocations

	distributions.each do |distribution|
		distribution_deletion = distribution.destroy
		if distribution_deletion == false
			puts "Could not delete distribution id: #{distribution['id']}"
		end
	end

	allocations.each do |allocation|
		allocation_deletion = allocation.destroy
		if allocation_deletion == false
			puts "Could not delete allocation id: #{allocation['id']}"
		end
	end

	success = account.destroy
	if success == true
		return true
	else
		return false
	end
end