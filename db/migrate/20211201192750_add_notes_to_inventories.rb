class AddNotesToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :notes, :string
  end
end
