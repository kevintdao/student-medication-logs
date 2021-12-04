class AddDistrictIdToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :districtID, :integer
  end
end
