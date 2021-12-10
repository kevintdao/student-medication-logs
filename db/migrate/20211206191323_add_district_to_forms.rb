class AddDistrictToForms < ActiveRecord::Migration
  def change
    add_column :forms, :districtID, :integer
  end
end
