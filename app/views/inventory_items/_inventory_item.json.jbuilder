json.extract! inventory_item, :id, :upc, :productName, :quantity, :employeeId, :photoUri, :signatureUri, :created_at, :updated_at
json.url inventory_item_url(inventory_item, format: :json)
