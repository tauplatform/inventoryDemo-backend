class InventoryItem < ActiveRecord::Base
  attr_accessible :upc, :productName, :quantity, :employeeId, :photoUri, :signatureUri
end
