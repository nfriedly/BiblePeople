class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.string :book
    end
  end

  def self.down
    drop_table :books
  end
end
