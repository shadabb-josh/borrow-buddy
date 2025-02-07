class TransactionService
  def create_transaction(params)
    transaction = Transaction.create(params)
    if transaction.persisted?
      transaction
    else
      raise StandardError.new(transaction.errors.full_messages)
    end
  end
end
