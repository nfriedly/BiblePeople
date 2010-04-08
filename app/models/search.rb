class Search

  @query = nil
  @in = nil
  @terms = []
  

  def self.search(query, page)
    @query = query
    if(query) 
      self.parse(query)
    end
    @query = "" if isRefference
    Verse.search(@query, page, @in)
  end

  def self.refference
    @in
  end

  def self.terms
    @terms
  end

  def self.parse(query)
    @query = query
    if (query.include? " IN ")
      parts = query.split(" IN ")
      in_str = parts.pop
      @query = parts.join(" ") # in case they used " in " twice (?)
      require 'refference.rb'
      @in = Refference.new(in_str)
      if(!@in.isValid)
        @in = nil
      end
    end
    @terms = @query.split.collect {|c| c.downcase } # is downcase necessary?
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