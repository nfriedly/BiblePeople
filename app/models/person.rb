class Person < ActiveRecord::Base
  has_many :person_verses
  has_many :verses, :through => :person_verses
  
  has_many :names
end
