class CreateProcessedImages < ActiveRecord::Migration
  def change
    create_table :processed_images do |t|
      t.string :local_src

      t.timestamps null: false
    end
  end
end
