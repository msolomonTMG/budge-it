#just like Sources are Allocated to Accounts
#Envelopes are populated by the Distribution of the Account (accounts are funded by source allocation)
class Distribution
	include DataMapper::Resource

	property :id, Serial
	property :amount, Float

	belongs_to :account#,	:key => true
	belongs_to :envelope#, 	:key => true
end