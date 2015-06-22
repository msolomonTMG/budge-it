def create_account (name)
	account = Account.create(
		:name => name
	)
end