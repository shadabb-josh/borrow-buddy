class RenamePinToPinDigestInUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :pin, :pin_digest
  end
end
