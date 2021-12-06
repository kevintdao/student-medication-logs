class ChangeColumn < ActiveRecord::Migration
  def change
    change_column :forms, :body, :text, :limit => 100000
  end
end
