class UserDestroy
  def initialize(user)
    @user = user
  end

  def destroy
    if @user.destroy
      { 'message': I18n.t("responses.users.deleted") }
    else
      raise StandardError.new(@user.errors.full_messages.join(", "))
    end
  end
end
