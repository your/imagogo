class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.string :operation_type
      t.string :status

      t.timestamps null: false
    end
  end
end
