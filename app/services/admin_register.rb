class AdminRegister
  def initialize(admin_params)
    @admin_params = admin_params
  end

  def create
    admin = Admin.new(@admin_params)

    if admin.save
      admin
    else
      raise StandardError.new(admin.errors.full_messages)
    end
  end
end
