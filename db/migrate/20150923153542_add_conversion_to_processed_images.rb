class AddConversionToProcessedImages < ActiveRecord::Migration
  def change
    add_reference :processed_images, :processed_image, index: true, foreign_key: true
  end
end
