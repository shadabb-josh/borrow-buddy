class CreateAdmins < ActiveRecord::Migration[7.2]
  def change
    create_table :admins do |t|
      t.string :username
      t.string :password_digest
      t.timestamps
    end
  end
end
