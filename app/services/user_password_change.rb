class UserPasswordChange
  def initialize(user, change_password_params)
    @user = user
    @old_password = change_password_params[:old_password]
    @new_password = change_password_params[:new_password]
  end

  def call
    unless @user.authenticate(@old_password)
      raise StandardError.new(I18n.t("user.incorrect_old_password"))
    end

    return success_message if @user.update(password: @new_password)
    raise StandardError.new(@user.errors.full_messages.join(", "))
  end

  private

  def success_message
    { message: I18n.t("user.password_change") }
  end
end
