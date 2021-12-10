class CreateJoinTableParentsStudents < ActiveRecord::Migration
  def change
    create_join_table :parents, :students do |t|
      # t.index [:parent_id, :student_id]
      # t.index [:student_id, :parent_id]
    end
  end
end
