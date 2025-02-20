class TransactionCreator
  def initialize(transaction_params)
    @sender_id = transaction_params[:sender_id]
    @receiver_id = transaction_params[:receiver_id]
    @amount = transaction_params[:amount].to_f
    @loan_id = transaction_params[:loan_id]
    @entered_pin = transaction_params[:entered_pin].to_s
  end

  def call(repayment = false)
    id_equal?
    amount_numeric?

    @sender = User.find(@sender_id)
    @receiver = User.find(@receiver_id)

    amount_valid?
    status_active?

    unless @sender.authenticate_pin(@entered_pin)
      raise StandardError.new(I18n.t("bank.invalid_pin"))
    end

    ActiveRecord::Base.transaction do
      @sender.update_columns(balance: @sender.balance - @amount)
      @receiver.update_columns(balance: @receiver.balance + @amount)

      Transaction.create(user_id: @sender.id, loan_id: @loan_id, amount: @amount, transaction_type: 2)
      Transaction.create(user_id: @receiver.id, loan_id: @loan_id, amount: @amount, transaction_type: 0)
    end
    if repayment
      true
    else
      { message: I18n.t("bank.transaction_complete") }
    end
  end

  private

  def id_equal?
    raise StandardError.new(I18n.t("bank.sender_reciever_id_equal")) if @sender_id == @receiver_id
  end

  def status_active?
    raise StandardError.new(I18n.t("bank.account_not_active")) if @sender.status != "active" || @receiver.status != "active"
  end

  def amount_numeric?
    raise StandardError.new(I18n.t("bank.amount_not_numeric")) unless @amount.to_s.match?(/\A\d+(\.\d+)?\z/)
  end

  def amount_valid?
    raise StandardError.new("bank.amount_negative") if @amount <= 0
    raise StandardError.new("bank.amount_insufficient_balance") if @sender.balance < @amount
  end
end
