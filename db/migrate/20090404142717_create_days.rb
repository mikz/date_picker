class CreateDays < ActiveRecord::Migration
  def self.up
    create_table :days do |t|
      t.column  :id, 'serial'
      t.integer :user_id, :null => false
      t.date    :date, :null => false
      t.timestamps
    end
    constrain :days do |t|
      t[:date,:user_id].all :unique => true
    end
  end

  def self.down
    drop_table :days
  end
end
