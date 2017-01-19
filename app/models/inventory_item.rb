class InventoryItem < ActiveRecord::Base
  attr_accessible :upc, :productName, :quantity, :employeeId, :picture0Uri, :picture1Uri, :signatureUri
end
