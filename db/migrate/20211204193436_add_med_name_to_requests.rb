class AddMedNameToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :med_name, :string
  end
end
