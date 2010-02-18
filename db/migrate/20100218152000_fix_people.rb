class FixPeople < ActiveRecord::Migration

  def self.up
    add_column :people, :father_id, :integer
    add_column :people, :mother_id, :integer
  end

  def self.down
    remove_column :people, :father_id
    remove_column :people, :mother_id
  end

end