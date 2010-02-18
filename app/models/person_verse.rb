class PersonVerse < ActiveRecord::Base
  belongs_to :person
  belongs_to :verse
end
