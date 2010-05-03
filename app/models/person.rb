class Person < ActiveRecord::Base
  has_many :person_verses, :dependent => :destroy
  has_many :verses, :through => :person_verses
  
  has_many :names, :dependent => :destroy
  
  has_many :children_fathered, :class_name => "Person" , :foreign_key =>
'father_id' 

  has_many :children_mothered, :class_name => "Person" , :foreign_key =>
'mother_id' 
  
  belongs_to :father, :class_name => 'Person', :foreign_key => 'father_id' 
  belongs_to :mother, :class_name => 'Person', :foreign_key => 'mother_id' 

  def name_attributes=(name_attributes)
    name_attributes.each do |name|
      names.build({:name => name})
    end
  end
  
  def verse_attributes=(verse_attributes)
    verse_attributes.each do |vid|
      person_verses.build({:verse_id => vid[0]})
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
    ""
  end
  
  def childWord
    if(gender == "m")
      return "son"
    end
    if(gender == "f")
      return "daughter"
    end
    "child"
  end
  
  def parentWord
    if(gender == "m")
      return "father"
    end
    if(gender == "f")
      return "mother"
    end
    "parent"
  end
  
  def children
      if(children_fathered.length > 0)
        return children_fathered
      end
      if(children_mothered.length > 0)
        return children_mothered
      end
      return []
  end
  
  def siblings
    siblings = []
    if(mother && father)
      # careful! playing with the arrays directly changes the database!
      mkids = mother.children[0, mother.children.length] 
      fkids = father.children[0, father.children.length]
      siblings = mkids.concat(fkids) # mother.children.concat(father.children)
    else
      if(mother)
        siblings = mother.children[0, mother.children.length]  # mother.children
      end
      if(father)
        siblings = father.children[0, father.children.length] # father.children
      end
    end
    # remove any duplicates and remove the person himself
    siblings.uniq!
    siblings.delete_if { |p| p.id == id }
  end
  
  # if called with no arguments, returns a link to the person
  # if called with a string or array of words, it finds refferences to itself, links those, and returns the result in the same format
  def linkName ( text=nil, thisName=nil)
    thisName = thisName || name
    if !text
      return '<a href="' + link  + '" class="person ' + genderName + '">' + thisName + '</a>'
    end
    
    # make sure we're working with an array, but remember to return a string if we were given one
    stringMode = text.is_a? String
    text = text.split " " if stringMode
    
    # scan each word for each of the person's names
    text.each do |word|
      names.each do |name|
        if(word.include?(name.name) && !word.include?('<a') ) # no double-linking
          word.sub! ( name.name, linkName( nil, name.name ) )
        end
      end
    end
    
    text = text.join(' ') if stringMode
    return text
  end
  
  # uses the last name in the database if multiple exist
  # or the id if more than one person shares that name
  def link
    #todo: allow the user to select which name to use
    n = names.reverse[0].name
    if Name.isMultiplePeople(n)
        link_id = id
    else 
        link_id = n
    end
    '/people/' + link_id.to_s
  end
  
  # for checking if it's a name or an id that's passed in
  def self.numeric?(object)
    true if Float(object) rescue false
  end
  
  # returns an array of people - may return more than 1 if it's a common name, or may return 0 if the person's not found
  def self.findByNameOrId(name_or_id)
    if numeric? name_or_id
      person = find(name_or_id)
      if(person) 
        return [person]
      else
        return []
      end
    else 
      return find(:all, {
        :joins => :names, 
        :conditions => ['name like ?', name_or_id.to_s]
      })
    end
  end
  
end
