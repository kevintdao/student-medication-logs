class AddAmountToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :amount, :integer
    add_column :requests, :units, :string
  end
end
