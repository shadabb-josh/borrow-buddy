class UserUpdate
  def initialize(user, user_params)
    @user = user
    @user_params = user_params
  end

  def update
    if @user.update(@user_params)
      @user
    else
      raise StandardError.new(@user.errors.full_messages.join(", "))
    end
  end
end
