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




end
