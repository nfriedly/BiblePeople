class Search

  @query = nil
  @in = nil
  @terms = nil
  

  def self.search(query, page)
    @query = query
    if(query) 
      self.parse(query)
    end
    Verse.search(@terms, page, @in)
  end

  def self.refference
    @in
  end

  def self.terms
    @terms
  end

  def self.parse(query)
    
    require 'refference.rb'
    
    @query = query
    
    # first see if the query has an IN portion with a refference following
    if (query.include? " IN ")
      parts = query.split(" IN ")
      in_str = parts.pop
      @in = Refference.new(in_str)    
      if(@in && @in.isValid)
        @terms = parts.join.split # back to a string, then split on whitespace
      end
    # if there wasn't an IN portion, try the entire thing as a refference
    else
      @in = Refference.new(query)
      if(@in && @in.isValid)
        @terms = []
      end
    end
    
    # cleanup
    # put @in back to null if it's no good
    if(@in && !@in.isValid)
      @in = nil
    end
    # set the terms to everything if they havn't been set yet
    if(!@terms.is_a?(Array))
      @terms = @query.downcase 
    end
  end

  def self.isRefference
    return false if(@in && @terms.length)
    require 'refference.rb'
    @in = Refference.new(@query)
    if(@in.isValid)
      return true
    else 
      #@in = nil
      return false
    end
  end

  def self.isBook
    @terms.length == 1 && Book.findBooks(@terms).length == 1
  end

  def self.isPerson
    #@terms.length == 1 && Book.findBooks(@terms).length == 1
    false
  end

  def self.constraint
    
  end
end