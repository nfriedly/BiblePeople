class Person < ActiveRecord::Base
  has_many :person_verses
  has_many :verses, :through => :person_verses
  
  has_many :names

  def name_attributes=(name_attributes)
    name_attributes.each do |name|
      names.build({:name => name})
    end
  end
  
  def name
      arrStrNames = []
      names.each{ |n| arrStrNames << n.name }
      arrStrNames.join(", ")
  end
  
end
