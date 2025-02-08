class UserPasswordChange
  def initialize(user, change_password_params)
    @user = user
    @old_password = change_password_params[:old_password]
    @new_password = change_password_params[:new_password]
  end

  def change_password
    unless @user.authenticate(@old_password)
      raise StandardError.new(I18n.t("responses.users.incorrect_old_password"))
    end

    if @user.update(password: @new_password)
      { message: I18n.t("responses.users.password_change") }
    else
      raise StandardError.new(@user.errors.full_messages.join(", "))
    end
  end
end
