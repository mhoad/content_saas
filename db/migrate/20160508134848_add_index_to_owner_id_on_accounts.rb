class AddIndexToOwnerIdOnAccounts < ActiveRecord::Migration[5.0]
  def change
    add_index :accounts, :owner_id
  end
end
