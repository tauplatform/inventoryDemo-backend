class AddUsernameToInventoryItem < ActiveRecord::Migration[5.0]
  def change
    add_column :inventory_items, :username, :string
  end
end
