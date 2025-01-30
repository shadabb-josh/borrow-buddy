class CreateRepayments < ActiveRecord::Migration[7.2]
  def change
    create_table :repayments do |t|
      t.integer :loan_id
      t.float :amount_paid
      t.timestamps
    end
    add_foreign_key :repayments, :loans, column: :loan_id
  end
end
