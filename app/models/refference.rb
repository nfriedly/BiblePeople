class Refference

  @query = nil
  @type = nil # "verse" || "range"
  @sub = false # true = do not break down into a range

  # range variables
  @start = nil # a second instance or Refference
  @end = nil # and a third instance of Refference

  # verse variables
  @level= nil # "book", "chapter", or "verse"
  @book = nil
  @chapter = nil
  @verse = nil

  def initialize(query=nil, sub=false, start=nil)
    @logger = RAILS_DEFAULT_LOGGER
    @query = query
    if(start)
	expandFrom(start)
    end
    if(query)
      parse(query)
    end

    strSub = (sub) ? 'sub-' : ''
    strStart = (start) ? ' and ' + start.pretty : ''
    @logger.info strSub + 'refference initalized from "' + query +'"'+ strStart + ' to ' + pretty 
    @logger.info ' - type: ' + @type.to_s + ' at '+ ' specificity: ' + @level.to_s  
    @logger.info (' - details: ' + ( (@book) ? @book.book.to_s : '' ) + ' ' + @chapter.to_s + ' v:' + verse.to_s) if !sub
    @sub = sub
  end

  def parse(query = nil)
    if(!query) 
      query = @query
    end
    if (query.include? "-")
      @type = "range"
      parts = query.split("-")
      @start = Refference.new(parts[0], true)
      @end = Refference.new(parts[1], true, @start)
    else
      @type = "verse"
      getBook
      getChapter
      getVerse
    end
  end

  def expandFrom(start)
    @start = start
    if(!@book) 
      @book = start.book
    end
    if(start.specificity == "verse") 
      if(self.secondNum)
        @verse = self.secondNum
        @chapter = self.firstNum
      else
        @verse = self.firstNum
        @chapter = start.chapter
      end
    else 
      if(start.specificity == "chapter")
        @chapter = self.firstNum
        @verse = nil
      end
    end
    
    @logger.info ' - Expanding from ' + start.pretty
    @logger.info '   -  type: ' + @type.to_s + ' at ' + ' specificity: '  + @level.to_s
    @logger.info ('   -  details: ' + @book.book.to_s + ' ' + @chapter.to_s + ' v:' + verse.to_s) if (!@sub)
    
  end

  def isValid
    return ((@type == "refference" && @start.isValid && @end.isValid) || (@type=="verse" && @book))
  end

  def pretty 
    return "" unless isValid
    str = nil
    if(@type == "verse")
      str = @book.book
      str += " #{@chapter}" if @chapter
      str += ":#{@verse}" if @verse
    end
    if(@type == "range")
      str = @start.pretty + " - " + @end.pretty
    end
    str
  end

  def sql
    return "1=1" unless isValid
    str = ""
    if(@type == "verse")
      str = "book_id = " + @book.id.to_s
      str += " AND chapter = " + @chapter if @chapter
      str += " AND verse = " + @verse if @verse
    end
    if(@type == "range")
      str = "book_id BETWEEN " + @start.book.id.to_s + " AND " + @end.book.id.to_s
      if (@start.specificity == "chapter" || @start.specificity == "verse")
        str += "chapter BETWEEN " + @start.chapter + " AND " + @end.chapter 
      end
      if(@start.specificity == "verse")
        str += "verse BETWEEN " + @start.verse + " AND " + @end.verse 
      end
    end
    str
  end

  # parsers
  def getBook
    books = Book.findBooks(@query)
    if(books && books.length == 1)
      @book = books[0]
      if(@book) 
        @level = "book"
      end
    end
  end

  def getChapter
    if(@book)
      if(@book.verse.maximum(:chapter) == 1)
        @chapter = 1
      else
        @chapter = firstNum
      end
    end
    if(@chapter)
      @level = "chapter"
    end
  end

  def getVerse
    strLog =  '   - getting verse - '
    if(@book && @chapter)
      if(@book.verse.maximum(:chapter)  == 1)
        @verse = firstNum
	 strLog += 'one chapter, verse is first number: '  + @verse.to_s
      else
        @verse = secondNum
        strLog += 'multiple chapters, verse is second number: ' + @verse.to_s
      end
      if(@verse)
        @level= "verse"
      end
    else
      strLog += 'one or both of book and chapter are missing. Skipping verse.'
    end
    @logger.info strLog
  end

  def firstNum
    getNum(0)
  end

  def self.firstNum
    firstNum
  end
  
  def secondNum
    getNum(1)
  end

  def self.secondNum
    secondNum
  end

  #todo: catch if a book name is "2 kings"
  def getNum(which)
    nums = @query.scan(/[0-9]+/)
    @logger.info ' finding ' + which.to_s + ' number in ' + @query + ' ('+nums.to_s+')' 
    if(nums && nums.length >= which)
      return nums[which]
    else 
      return nil
    end
  end
  
  
# getters and setters
  def book(book=nil)
    if(book) 
      @book = book
      @level= "book"
    end
    @book
  end

  def chapter(chap=nil)
    if(chap) 
      @chapter = chap
      @level= "chapter"
    end
    @chapter
  end

  def verse(verse=nil)
    if(verse) 
      @verse = verse
      @level= "verse"
    end
    @verse
  end

  def query(query=nil)
    if(query) 
      @query= query
    end
    @query
  end

  # convience - I changed the name because I kept misspelling specificity
  def specificity (specificity=nil)
    level(specificity)
  end

  def level(l=nil)
    if(l) 
      @level= l
    end
    @level
  end

end