class CreateMedications < ActiveRecord::Migration
  def change
    create_table :medications do |t|
      t.string :brand_name
      t.string :active_ing
      t.string :uses
      t.string :method
      t.text :reactions
      t.string :side_effects
      t.string :array

      t.timestamps null: false
    end
  end
end
