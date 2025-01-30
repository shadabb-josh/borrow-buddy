class CreateLoans < ActiveRecord::Migration[7.2]
  def change
    create_table :loans do |t|
      t.integer :borrower_id
      t.integer :lender_id
      t.float :amount
      t.float :interest
      t.string :purpose
      t.date :repayment_till
      t.float :expected_return
      t.integer :status, default: 0
      t.timestamps
    end
    add_foreign_key :loans, :users, column: :borrower_id
    add_foreign_key :loans, :users, column: :lender_id
  end
end
