class Verse < ActiveRecord::Base
  belongs_to :book

  has_many :person_verses
  has_many :people, :through => :person_verses

  def self.search(search, page, ref=nil, strict=true)
    # a list of possible characters allowed to occur before or after words
    # (essentially, we're making a list of characters that define word-boundrys)
    before = [' ','(']
    after = [' ','.',',',':',';','!','?',')']
  
    # make sure we're working with an array here
    search = search.split if search.is_a? String
    
    conditions = []
    search.each{ |term| #(/\s+/)
      if strict
        
        # we're going to have a sub-section for each word in the query
        wordConditions = []
        
        # cases where the word is the last word in the verse
        before.each{ |b|
          wordConditions << "text like " + sanitize('%' + b + term) 
        }

        # cases where the word is the first word in the verse
        after.each{ |a|
          wordConditions << "text like " + sanitize(term + a + '%') 
        }

        #cases where the word is somewhere in the middle of the verse
        before.each{ |b|
          after.each{ |a|
            wordConditions << "text like " +sanitize('%' + b + term + a + '%')
          }
        }
        
        # glue it all together and add it to the list of conditions
        conditions << '(' + wordConditions.join(' OR ') + ')';
      else
        # in non-strict mode, we skip all the word-boundry bits
        conditions << "text like " + sanitize('%' + term + '%') 
      end
    }
    if(ref) 
      conditions << ref.sql
    end
    
    # glue all of our conditions together
    conditions = conditions.join(" AND ")
    
    #if the strict search returns no results, do a non-strict one instead
    #finding :one is a lot faster than doing count(:all, :conditions => conditions) 
    # wrapped in a try/catch because it fails sometimes :/
    begin
      if strict && find(:first, :conditions => conditions) == nil
        return search(search, page, ref, false)
      end
    rescue
      # do nothing, the next one should work
    end
    
    paginate :per_page => 20, :page => page,
           :conditions => conditions
  end

#  def self.searchName(name, type=:paged, page=0, per_page=20)
#    if(type == :all)
#      return find(:all, ["text like ?", '%' + name + '%'])
#    else
#      return paginate :per_page => per_page, :page => page,
#           :conditions => ["text like ?", '%' + name + '%']
#    end
#  end
  
  def refference 
    book.book + " " + chapter.to_s + ":" + verse.to_s
  end
  
  #defined here because the url helper isn't easy to access from within the model
  def linkedText (span=false, highlight=[])
    
    # if there's no spans, no highlight, and no people to link, then this should be easy as pie
    return text if ( !span && !highlight && person_verses.length == 0 ) 
    
    if ! highlight.is_a? Array
      highlight = highlight.split(' ')
    end

    #otherwise, we've got some work to do. first make an array to hold all of our results
    linkedWords = []
    words = text.split " "
    
    #link the names first
    people.each do |person|
      words = person.linkName(words)
    end
    
    #scan each word
    words.each do |word|
      hit = false
      oword = word
              
      # highlight it if appropriate
      highlight.each do |hword|
        if word.downcase.include?(hword.downcase)
          hit = true
          if word.include? '<' 
            # more exact method disabled when links are present 
            word = '<span class="highlight">' + word + '</span>'
          else
            pattern = Regexp.new('('+hword+')', true)  # case-insensitive, refference capturing regex
            word.sub! pattern, '<span class="highlight">\\1</span>'
          end
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
