class UserService
  def self.create_user(user_params)
    user = User.create(user_params)
    if user.persisted?
      user
    else
      raise StandardError.new(user.errors.full_messages.join(", "))
    end
  end

  def self.update_user(user, user_params)
    if user.update(user_params)
      user
    else
      raise StandardError.new(user.errors.full_messages.join(", "))
    end
  end

  def self.delete_user(user)
    if user.destroy
      { message: I18n.t("responses.users.deleted") }
    else
      raise StandardError.new(user.errors.full_messages.join(", "))
    end
  end

  def self.change_password(user, change_password_params)
    old_password = change_password_params[:old_password]
    new_password = change_password_params[:new_password]

    unless user.authenticate(old_password)
      raise StandardError.new(I18n.t("responses.users.incorrect_old_password"))
    end

    if user.update(password: new_password)
      { message: I18n.t("responses.users.password_change") }
    else
      raise StandardError.new(user.errors.full_messages.join(", "))
    end
  end
end
