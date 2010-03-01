class AddGenderToPeople < ActiveRecord::Migration

  def self.up
    add_column :people, :gender, :string, :limit => 2, :null => true
  end

  def self.down
    remove_column :people, :gender
  end

end