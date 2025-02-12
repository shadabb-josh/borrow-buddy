class AddBankDetailsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :account_number, :string
    add_column :users, :ifsc, :string
    add_column :users, :pin, :string
    add_column :users, :balance, :decimal
  end
end
