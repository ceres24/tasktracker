class ChangeEmailNotificationsBlobToText < ActiveRecord::Migration
  def self.up
    change_column :users, :email_notifications, :text
  end

  def self.down
    change_column :users, :email_notifications, :binary
  end
end
