class Refference

  @query = nil
  @type = nil # "verse" || "range"
  @sub = false # true = do not break down into a range

  # range variables
  @start = nil # a second instance or Refference
  @end = nil # and a third instance of Refference

  # verse variables
  @specificity= nil # "book", "chapter", or "verse"
  @book = nil
  @chapter = nil
  @verse = nil

  def initialize(query = nil, sub=false)
    @query = query
    if(query)
      parse(query)
    end
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
      @end = Refference.new(parts[1], true)
      @end.expandFrom(@start)
    else
      @type = "verse"
      getBook
      getChapter
      getVerse
    end
  end

  def expandFrom(start)
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
    elseif(start.specificity == "chapter")
      @chapter = self.firstNum
      @verse = nil
    end
  end

  def isValid
    return ((@type == "refference" && @start.isValid && @end.isValid) || (@type=="verse" && @book))
  end

  def pretty 
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

  # getters and setters
  def book(book=nil)
    if(book) 
      @book = book
      @specificity = "book"
    end
    @book
  end

  def chapter(chap=nil)
    if(chap) 
      @chapter = chap
      @specificity = "chapter"
    end
    @chapter
  end

  def verse(verse=nil)
    if(verse) 
      @verse = verse
      @specificity = "verse"
    end
    @verse
  end

  def query(query=nil)
    if(query) 
      @query= query
    end
    @query
  end

  def specificity (specificity=nil)
    if(specificity) 
      @specificity = specificity
    end
    @specificity
  end


  # parsers
  def getBook
    books = Book.findBooks(@query)
    if(books && books.length == 1)
      @book = books[0]
      if(@book) 
        @specificity = "book"
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
      @specificity = "chapter"
    end
  end

  def getVerse
    if(@book && @chapter)
      if(@book.verse.maximum(:chapter)  == 1)
        @verse = firstNum
      else
        @verse = secondNum
      end
      if(@verse)
        @specificity = "verse"
      end
    end
  end

  def firstNum
    getNum(1)
  end

  def self.firstNum
    firstNum
  end
  
  def secondNum
    getNum(2)
  end

  def self.secondNum
    secondNum
  end

  def getNum(which)
    nums = /[0-9]+/.match(@query)
    if(nums && nums.length >= which)
      return nums[which]
    else 
      return nil
    end
  end
end