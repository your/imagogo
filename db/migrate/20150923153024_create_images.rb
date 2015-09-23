class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :remote_src
      t.string :local_src
      t.string :resized_src

      t.timestamps null: false
    end
  end
end
