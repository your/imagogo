class AddNullConstraintToProcessedImageImage < ActiveRecord::Migration
  def change
    change_column_null :processed_images, :image_id, false
  end
end
