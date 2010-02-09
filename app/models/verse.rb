class Verse < ActiveRecord::Base
  belongs_to :book

  def self.search(search, page)
    conditions = []
    search.split(/\s+/).map{ |term| 
      conditions << "text like " + sanitize('%' + term + '%') 
    }
    paginate :per_page => 20, :page => page,
           :conditions => conditions.join(" AND ")
  end




end
