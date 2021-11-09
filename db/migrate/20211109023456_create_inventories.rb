class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.integer :med_id
      t.integer :amount

      t.timestamps null: false
    end
  end
end
