class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.int :father_id
      t.int :mother_id
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
