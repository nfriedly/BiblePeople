class Book < ActiveRecord::Base
  has_many :verse

  def self.findBooks(words)
    if(words.class == " ".class)
      words = words.split
    end
    conditions = []
    if(words.length)
      if(["1", "2", "3", "I", "II", "III"].include? words[0].upcase)
        num = words.shift
        num = num.length.to_s if num.upcase.include? "I"
        words[0] = num + " " + words[0]
      end
    end
    words.map{ |word|
      conditions << " book like " + sanitize(word + '%') if  not_a_word? word
    }
    find(:all, :conditions => conditions.join(" OR ")) unless conditions.length == 0
  end

  def self.bookName(name)
    find(:one, :conditions => ["name like ?",name]);
    if(self.length) 
      return self.name
    else 
      return nil
    end
  end

  def self.chapters(book)
    book.verses.maximum('chapter')
  end

  def self.not_a_word?(s)
    s.match(/[a-zA-Z]+/) == nil ? false : true 
  end

end
