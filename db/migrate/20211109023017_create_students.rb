class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.text :meds
      t.text :events
      t.string :year
      t.text :parents

      t.timestamps null: false
    end
  end
end
