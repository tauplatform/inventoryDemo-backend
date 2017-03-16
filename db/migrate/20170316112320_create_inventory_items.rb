class CreateInventoryItems < ActiveRecord::Migration[5.0]
  def change
    create_table :inventory_items do |t|
      t.string :upc
      t.string :productName
      t.integer :quantity
      t.string :employeeId
      t.string :photoUri
      t.string :signatureUri

      t.timestamps
    end
  end
end
