class AddImageToConversions < ActiveRecord::Migration
  def change
    add_reference :conversions, :image, index: true, foreign_key: true
  end
end
