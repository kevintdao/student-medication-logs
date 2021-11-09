class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.references :medications
      t.references :events
      t.string :year
      t.references :parents

      t.timestamps null: false
    end
  end
end
