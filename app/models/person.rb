class Person < ActiveRecord::Base
  has_many :person_verses
  has_many :verses, :through => :person_verses
  
  has_many :names
  
  has_many :children_fathered, :class_name => "Person" , :foreign_key =>
'father_id' 

  has_many :children_mothered, :class_name => "Person" , :foreign_key =>
'mother_id' 
  
  belongs_to :mother, :class_name => 'Person', :foreign_key =>
'mother_id' 
  belongs_to :father, :class_name => 'Person', :foreign_key =>
'father_id' 

  def name_attributes=(name_attributes)
    name_attributes.each do |name|
      names.build({:name => name})
    end
  end
  
  def name=(name_attributes)
     name_attributes.each do |name|
       # do something here
    end   
  end
  
  def name
      arrStrNames = []
      names.each{ |n| arrStrNames << n.name }
      arrStrNames.join(", ")
  end
    
  def fatherName
    if(father)
      return father.name
    end
  end
  
  def motherName
    if(mother)
      return mother.name
    end
  end
  
  def genderName
    if(gender == "m")
      return "Male"
    end
    if(gender == "f")
      return "Female"
    end
  end
  
  def children
      if(children_fathered.length)
        return children_fathered
      end
      if(children_mothered.length)
        return children_mothered
      end
      return []
  end
  
  def self.findSiblings p
    find :all, :conditions => [ "(father_id = ? OR mother_id = ?) AND id != ?", p.father_id, p.mother_id, p.id ]
  end
  
  
end
