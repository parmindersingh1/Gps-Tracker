class CreateGpslocations < ActiveRecord::Migration
  def self.up
    create_table :gpslocations do |t|
      t.decimal :latitude,  precision: 10, scale: 7
      t.decimal :longitude,  precision: 10, scale: 7
      t.string :phoneNumber
      t.string :userName
      t.string :sessionID
      t.integer :speed
      t.integer :direction
      t.decimal :distance,  precision: 10, scale: 1
      t.timestamp :gpsTime
      t.string :locationMethod
      t.integer :accuracy
      t.string :extraInfo
      t.string :eventType

      t.timestamps
    end
     add_index :gpslocations, :sessionID, :name=>'sessionIDIndex'
     add_index :gpslocations, :phoneNumber, :name=>'phoneNumberIndex'
     add_index :gpslocations, :userName, :name=>'userNameIndex'
  end
  def self.down
    remove_index :gpslocations, 'sessionIDIndex'
    remove_index :gpslocations, 'phoneNumberIndex'
    remove_index :gpslocations, 'userNameIndex'
  end
end
