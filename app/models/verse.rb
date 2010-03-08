class Verse < ActiveRecord::Base
  belongs_to :book

  has_many :person_verses
  has_many :people, :through => :person_verses

  def self.search(search, page, refference)
    conditions = []
    search.split(/\s+/).map{ |term| 
      conditions << "text like " + sanitize('%' + term + '%') 
    }
    if(refference) 
      conditions << refference.sql
    end
    paginate :per_page => 20, :page => page,
           :conditions => conditions.join(" AND ")
  end

  def self.searchName(name, type=:paged, page=0, per_page=20)
    if(type == :all)
      return find(:all, ["text like ?", '%' + name + '%'])
    else
      return paginate :per_page => per_page, :page => page,
           :conditions => ["text like ?", '%' + name + '%']
    end
  end
  
  def refference 
    book.book + " " + chapter.to_s + ":" + verse.to_s
  end
  
  #defined here because the url helper isn't easy to access from within the model
  def linkedText (span=false, highlight=[])
    
    # if there's no spans, no highlight, and no people to link, then this should be easy as pie
    return text if ( !span && !highlight && person_verses.length == 0 ) 
    
    if ! highlight.is_a? Array
      highlight = [highlight]
    end

    #otherwise, we've got some work to do. first make an array to hold all of our results
    linkedWords = []
    words = text.split " "
    
    #check it for people we should be linking
    people.each do |person|
      words = person.linkName words
    end
    
    #scah each word
    words.each do |word|
      hit = false
      
      # highlight it if appropriate
      highlight.each do |hword|
        if word.include?(hword)
          word.sub! hword, '<span class="highlight">' + hword + '</span>'
          hit = true
        end
      end
      
      # and if it's not a person and not highlighted, but we are looking for individual words, <span> it
      if( span && !hit && !word.include?('<a') )
        word = "<span>" + word + "</span>"
      end
      
      # save the changes to our list of words
      linkedWords << word
    end
    
    # return our results
    linkedWords.join(' ')
  end

end
