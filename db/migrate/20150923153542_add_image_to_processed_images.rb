class AddImageToProcessedImages < ActiveRecord::Migration
  def change
    add_reference :processed_images, :image, index: true, foreign_key: true
    change_column_null :processed_images, :image, false
  end
end
