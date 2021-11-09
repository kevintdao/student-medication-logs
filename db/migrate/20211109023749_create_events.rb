class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :time
      t.integer :student_id
      t.integer :med_id
      t.boolean :complete
      t.string :notes

      t.timestamps null: false
    end
  end
end
