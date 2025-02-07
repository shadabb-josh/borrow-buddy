class AdminService
  def self.create_admin(params)
    admin = Admin.create(params)
    if admin.persisted?
      admin
    else
      raise StandardError.new(admin.errors.full_messages.join(", "))
    end
  end

  def self.update_admin(admin, params)
    if admin.update(params)
      admin
    else
      raise StandardError.new(admin.errors.full_messages.join(", "))
    end
  end

  def self.delete_admin(admin)
    if admin.destroy
      { message: "Admin deleted successfully" }
    else
      raise StandardError.new(admin.errors.full_messages.join(", "))
    end
  end
end
