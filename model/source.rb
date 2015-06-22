#Income sources are deposited into accounts through allocations
class Source
	include DataMapper::Resource

	property :id, Serial
	property :name, String
	property :amount, Float

	has n, :allocations, :required => false
	has n, :accounts, :through => :allocations
end