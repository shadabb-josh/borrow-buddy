class AdminUpdate
  def initialize(admin, admin_params)
    @admin = admin
    @admin_params = admin_params
  end

  def update
    if @admin.update(@admin_params)
      @admin
    else
      raise StandardError.new(@admin.errors.full_messages)
    end
  end
end
