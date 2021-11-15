class CreateMedications < ActiveRecord::Migration
  def change
    create_table :medications do |t|
      t.string :brand_name
      t.string :active_ing
      t.string :method
      t.string :strength
      t.string :notes

      t.timestamps null: false
    end
  end
end
