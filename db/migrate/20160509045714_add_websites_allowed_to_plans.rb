class AddWebsitesAllowedToPlans < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :websites_allowed, :integer
  end
end
