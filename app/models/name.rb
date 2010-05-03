class Name < ActiveRecord::Base
  belongs_to :person

  # this has room for growth, for example, searching form [parent] begat [child]
  def self.suggestParent(child, whichParent, name)
    #searches = []
    #searches << {:conditions => ['text like ?'], 
    #User.union(searches, {:order => 'name', :limit => 10
    case whichParent
      when "father"
        not_gender = "f"
      when "mother"
      not_gender = "m"
      else
        not_gender = "-"
    end
    # 'name like ? AND gender != ?', name.to_s + '%', not_gender
    find(:all, {:joins => :person, :conditions => ['name like ?', name.to_s + '%'], :limit=>10})
  end
  
  def self.isName(name)
    hits = count( :conditions => ['name like ?', name.to_s] )
    return (hits > 0)
  end
  
  def self.isMultiplePeople(n)
    hits = count( :conditions => ['name like ?', n.to_s] )
    return (hits > 1)
  end

end
