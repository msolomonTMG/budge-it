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