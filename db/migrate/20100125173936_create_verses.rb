class CreateVerses < ActiveRecord::Migration
  def self.up
    drop_table :verses
    create_table :verses do |t|
      t.integer :book_id
      t.integer :chapter
      t.integer :verse
      t.string :text
    end
  end

  def self.down
    drop_table :verses
  end
end
