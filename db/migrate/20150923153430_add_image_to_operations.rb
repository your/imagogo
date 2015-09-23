class AddImageToOperations < ActiveRecord::Migration
  def change
    add_reference :operations, :image, index: true, foreign_key: true
    change_column_null :operations, :image, false
  end
end
