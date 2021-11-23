class AddDistrictToEvents < ActiveRecord::Migration
  def change
    add_column :events, :district, :integer
  end
end
