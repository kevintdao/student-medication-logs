class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.datetime :time1
      t.datetime :time2
      t.datetime :time3
      t.datetime :time4
      t.string :daily_doses
      t.datetime :start_date
      t.datetime :end_date
      t.integer :student_id
      t.integer :requestor_id
      t.integer :med_id
      t.integer :district_id
      t.string :notes
      t.boolean :parent_approved
      t.boolean :nurse_approved

      t.timestamps null: false
    end
  end
end
