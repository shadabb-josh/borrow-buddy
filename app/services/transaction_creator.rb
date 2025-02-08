class TransactionCreator
  def initialize(transaction_params)
    @transaction_params = transaction_params
  end

  def create
    transaction = Transaction.new(@params)

    if transaction.save
      transaction
    else
      raise StandardError.new(transaction.errors.full_messages)
    end
  end
end
