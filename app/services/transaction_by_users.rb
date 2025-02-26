class TransactionByUsers
  def initialize(user)
    @user_id = user.id
  end

  def transactions_by_users
    @transactions = Transaction.where(user_id: @user_id)
  end
end
