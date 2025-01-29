class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.integer :loan_id
      t.float :amount
      t.integer :transaction_type, default: 0
      t.timestamps
    end

    add_foreign_key :transactions, :users, column: :user_id
    add_foreign_key :transactions, :loans, column: :loan_id
  end
end
