class AdminRegister
  def initialize(admin_params)
    @admin_params = admin_params
  end

  def call
    admin = Admin.new(@admin_params)
    return admin if admin.save
    raise StandardError.new(admin.errors.full_messages)
  end
end
