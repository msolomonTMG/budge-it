
# ROUTES

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

# FUNCTIONS 

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