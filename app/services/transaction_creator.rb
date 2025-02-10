class TransactionCreator
  def initialize(transaction_params)
    @transaction_params = transaction_params
  end

  def call
    transaction = Transaction.new(@transaction_params)

    return transaction if transaction.save
    raise StandardError.new(transaction.errors.full_messages)
  end
end
