class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
      t.boolean :nurse_approved
      t.boolean :parent_approved
      t.string :complete_boolean
      t.string :body

      t.timestamps null: false
    end
  end
end
