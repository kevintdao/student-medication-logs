class AddMedNameToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :medName, :string
  end
end
