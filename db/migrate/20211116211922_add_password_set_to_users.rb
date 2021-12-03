class AddPasswordSetToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_set_token, :string
    add_column :users, :password_set_sent_at, :datetime
  end
end
