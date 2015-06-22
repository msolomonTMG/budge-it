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