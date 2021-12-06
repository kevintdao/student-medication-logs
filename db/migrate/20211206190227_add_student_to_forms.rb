class AddStudentToForms < ActiveRecord::Migration
  def change
    add_column :forms, :studentID, :integer
  end
end
