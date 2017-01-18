class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :upc
      t.string :productName
      t.string :damageReason
      t.string :employeeId
      t.string :picture0Uri
      t.string :picture1Uri
      t.string :signatureUri

      t.timestamps
    end
  end
end
