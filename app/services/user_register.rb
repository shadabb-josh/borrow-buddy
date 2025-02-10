class UserRegister
  def initialize(user_params)
    @user_params = user_params
  end

  def call
    user = User.new(@user_params)

    return user if user.save
    raise StandardError.new(user.errors.full_messages.join(", "))
  end
end
