
# ROUTES 

get '/envelopes' do
	@envelopes = Envelope.all
	i = 0
	while i < @envelopes.length do
		i += 1
	end
end

post '/envelope/create' do
	envelope = params[:envelope]
	envelope = create_envelope envelope['name'], envelope['balance'].to_f
	redirect "/#envelope#{envelope['id']}"
end

# FUNCTIONS 

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