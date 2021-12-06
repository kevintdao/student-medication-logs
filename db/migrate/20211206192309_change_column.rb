class ChangeColumn < ActiveRecord::Migration
  def change
    add_column :forms, :body, :text, :limit => 100000
  end
end
