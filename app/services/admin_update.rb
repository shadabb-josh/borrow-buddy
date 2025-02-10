class AdminUpdate
  def initialize(admin, admin_params)
    @admin = admin
    @admin_params = admin_params
  end

  def call
    return @admin if @admin.update(@admin_params)
    raise StandardError.new(@admin.errors.full_messages)
  end
end
