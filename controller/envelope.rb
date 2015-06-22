def create_envelope (name, balance)
	envelope = Envelope.create(
		:name => name,
		:balance => balance
	)
end

def delete_envelope (name)
	#if user != nil && action != nil
	envelope = Envelope.first(:name => name)
	envelope.name = name
	envelope.destroy
end