#Acccounts are collections of envelopes
#Sources have amounts that are allocated to accounts
#Amounts get deposited into each envelope according to a number
class Account
	include DataMapper::Resource

	property :id, Serial
	property :name, String

	has n, :allocations, :required => false
	has n, :sources, :through => :allocations

	has n, :distributions, :required => false
	has n, :envelopes, :through => :distributions
end
