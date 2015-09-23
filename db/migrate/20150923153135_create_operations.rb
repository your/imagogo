class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.string :operation_type
      t.datetime :enqueue_date
      t.datetime :start_date
      t.datetime :end_time
      t.string :status

      t.timestamps null: false
    end
  end
end
