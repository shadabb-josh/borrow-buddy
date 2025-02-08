class AdminDestroy
  def initialize(admin)
    @admin = admin
  end

  def destroy
    if @admin.destroy
      { message: I18n.t("responses.admins.deleted") }
    else
      raise StandardError.new(@admin.errors.full_messages)
    end
  end
end
