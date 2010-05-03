class PersonVerse < ActiveRecord::Base
  belongs_to :person
  belongs_to :verse
  
  def self.firstMention
    find(:first, :order => "verse_id ASC")
  end
end
