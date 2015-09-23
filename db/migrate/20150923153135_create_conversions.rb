class CreateConversions < ActiveRecord::Migration
  def change
    create_table :conversions do |t|
      t.string :conversion_type
      t.datetime :enqueue_date
      t.datetime :start_date
      t.datetime :end_time
      t.string :status

      t.timestamps null: false
    end
  end
end
