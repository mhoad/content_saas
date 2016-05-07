class AddAccountIdToWebsites < ActiveRecord::Migration[5.0]
  def change
    add_column :websites, :account_id, :integer
    add_index :websites, :account_id
  end
end
