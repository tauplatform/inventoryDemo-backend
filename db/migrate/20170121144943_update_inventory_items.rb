class UpdateInventoryItems < ActiveRecord::Migration
  def change
    remove_column :inventory_items, :picture0Uri
    remove_column :inventory_items, :picture1Uri
    add_column    :inventory_items, :photoUri, :string
  end
end
