def create_source (name, amount)
	source = Source.create(
		:name => name,
		:amount => amount
	)
end