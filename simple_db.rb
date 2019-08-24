class SimpleDb
	attr_accessor :state, :transactions

	class Transaction
		attr_accessor :state

		def initialize
			@state = {}
		end
	end

	def initialize
		@state = {}
		@transactions = []
	end

	def exists?(key)
		if transactions.any?
			open_transaction.state.has_key?(key)
		else
			state.has_key?(key)
		end
	end

	def get(key)
		if transactions.any?
			open_transaction.state[key]
		else
			state[key]
		end
	end

	def set(key, value)
		if transactions.any?
			open_transaction.state[key] = value
		else
			state[key] = value
		end
	end

	def unset(key)
		if transactions.any?
			open_transaction.state.delete(key)
		else
			state.delete(key)
		end
	end

	def begin
		transactions << Transaction.new
	end

	def commit
		state = open_transaction.state
	end

	def rollback
		transactions.pop
	end

	private

	def open_transaction
		transactions.last
	end
end
