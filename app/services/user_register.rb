class UserRegister
  def initialize(user_params)
    @user_params = user_params
  end

  def call
    user = User.new(@user_params)
    user.skip_validations = true
    if user.save
      UserMailer.welcome_email(user).deliver_later
      return user
    end
    raise StandardError.new(user.errors.full_messages.join(", "))
  end
end
