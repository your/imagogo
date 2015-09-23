class AddImageToOperations < ActiveRecord::Migration
  def change
    add_reference :operations, :image, index: true, foreign_key: true
  end
end
