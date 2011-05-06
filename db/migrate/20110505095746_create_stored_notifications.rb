class CreateStoredNotifications < ActiveRecord::Migration
  def self.up
    create_table :stored_notifications do |t|
      t.text :xml_data
      t.boolean :processed
      t.timestamps
    end
  end

  def self.down
    drop_table :stored_notifications
  end
end
