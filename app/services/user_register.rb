class UserRegister
  def initialize(user_params)
    @user_params = user_params
  end

  def create
    user = User.new(@user_params)

    if user.save
      user
    else
      raise StandardError.new(user.errors.full_messages.join(", "))
    end
  end
end
