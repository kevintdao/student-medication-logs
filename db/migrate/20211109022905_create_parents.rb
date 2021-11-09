class CreateParents < ActiveRecord::Migration
  def change
    create_table :parents do |t|
      t.text :students

      t.timestamps null: false
    end
  end
end
