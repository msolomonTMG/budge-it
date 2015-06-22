#Allocations are relationships between income sources and accounts
class Allocation
	include DataMapper::Resource

	property :id, Serial
	property :amount, Float

	belongs_to :account#,	:key => true
	belongs_to :source#, 	:key => true

end