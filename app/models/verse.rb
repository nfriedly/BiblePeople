class Verse < ActiveRecord::Base
  include ActionController::UrlWriter

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
  def linkedText (span=false, highlight=false)
    
    # if there's no spans, no highlight, and no people to link, then this should be easy as pie
    return text if ( !span && !highlight && person_verses.length == 0 ) 

    #otherwise, we've got some work to do. first make an array to hold all of our results
    linkedWords = []
    
    #scah each word
    text.split(' ').each do |word|
      hit = false
      
      # highlight it if appropriate
      # todo: replace include? with a reges so that things like "sergius paulus" don't get hit for "paul"
      if (highlight && word.include?(highlight) )
        word = '<span class="highlight">' + word + '</span>'
        hit = true
      end
      
      #check it for people we should be linking
      people.each do |person|
        person.names.each do |name|
          if(word.include? name.name) 
            word.sub! ( name.name, 
              link_to ( name.name, {
                :controller => 'people', 
                :action => 'show', 
                :id => person.id,
                :host => "biblepeople.info"
              })
            )
            hit = true
          end
        end
      end
      
      # and if it's not a person and not highlighted, but we are looking for individual words, <span> it
      if( span && !hit )
        word = "<span>" + word + "</span>"
      end
      
      # save the changes to our list of words
      linkedWords << word
    end
    
    # return our results
    linkedWords.join(' ')
  end

end
