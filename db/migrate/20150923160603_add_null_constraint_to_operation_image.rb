class AddNullConstraintToOperationImage < ActiveRecord::Migration
  def change
    change_column_null :operations, :image_id, false
  end
end
