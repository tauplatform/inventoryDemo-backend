class InventoryItem < ApplicationRecord
  def has_photo?
    photoUri != nil
  end
end
