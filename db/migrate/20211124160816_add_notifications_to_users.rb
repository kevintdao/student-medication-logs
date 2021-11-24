class AddNotificationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :text_notification, :boolean, default: false
    add_column :users, :email_notification, :boolean, default: false
  end
end
