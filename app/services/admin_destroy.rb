class AdminDestroy
  def initialize(admin)
    @admin = admin
  end

  def call
    return success_message if @admin.destroy
    raise StandardError.new(@admin.errors.full_messages)
  end

  private

  def success_message
    { message: I18n.t("admin.deleted") }
  end
end
