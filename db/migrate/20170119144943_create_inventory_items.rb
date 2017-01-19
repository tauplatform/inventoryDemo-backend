class CreateInventoryItems < ActiveRecord::Migration
  def change
    create_table :inventory_items do |t|
      t.string :upc
      t.string :productName
      t.string :quantity
      t.string :employeeId
      t.string :picture0Uri
      t.string :picture1Uri
      t.string :signatureUri
      t.timestamps
    end
  end
end