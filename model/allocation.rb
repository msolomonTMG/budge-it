#Allocations are relationships between income sources and accounts
class Allocation
	include DataMapper::Resource

	property :id, Serial
	property :amount, Float

	belongs_to :account
	belongs_to :source

end