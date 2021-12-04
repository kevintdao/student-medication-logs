class AddStudentIdToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :studentID, :integer
  end
end
