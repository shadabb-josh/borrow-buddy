class UserUpdate
  def initialize(user, user_params)
    @user = user
    @user_params = user_params
  end

  def call
    return @user if @user.update(@user_params)
    raise StandardError.new(@user.errors.full_messages.join(", "))
  end
end
