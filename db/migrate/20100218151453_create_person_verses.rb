class CreatePersonVerses < ActiveRecord::Migration
  def self.up
    create_table :person_verses do |t|
      t.integer :person_id
      t.integer :verse_id

      t.timestamps
    end
  end

  def self.down
    drop_table :person_verses
  end
end
