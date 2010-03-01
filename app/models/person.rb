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
    
  # this has room for growth, for example, searching form [parent] begat [child]
  def suggestParent(child, which, name)
    #searches = []
    #searches << {:conditions => ['text like ?'], 
    #User.union(searches, {:order => 'name', :limit => 10
    case which 
      when "father"
        not_gender = "f"
      when "mother"
      not_gender = "m"
      else
        not_gender = "-"
    end
    find(:all, {:conditions => ['name like ? AND gender != ?', name + '%', not_gender], :limit=>10})
  end
  
end
