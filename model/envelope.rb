#Envelopes are objects that host balances
#Envelopes receive their balances through the distribution of account allocations
class Envelope
	include DataMapper::Resource

	property :id, Serial
	property :name, String
	property :balance, Float

	has n, :distributions, :required => false
	has n, :accounts, :through => :distributions
end
