class UserDestroy
  def initialize(user)
    @user = user
  end

  def call
    return success_message if @user.destroy
    raise StandardError.new(@user.errors.full_messages.join(", "))
  end

  def success_message
    { 'message': I18n.t("user.deleted") }
  end
end
