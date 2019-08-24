class SimpleDb
	attr_accessor :state, :transactions

	class Transaction
		attr_accessor :state

		def initialize(state = {})
			@state = state
		end
	end

	def initialize
		@state = {}
		@transactions = []
	end

	def exists?(key)
		current_transaction.state.has_key?(key)
	end

	def get(key)
		current_transaction.state[key]
	end

	def set(key, value)
		current_transaction.state[key] = value
	end

	def unset(key)
		current_transaction.state.delete(key)
	end

	def begin
		transactions << Transaction.new(state: state)
	end

	def commit
		state = current_transaction.state
	end

	def rollback
		transactions.pop
	end

	private

	def current_transaction
		transactions.last || self
	end
end
