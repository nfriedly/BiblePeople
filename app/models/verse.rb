class Verse < ActiveRecord::Base
  belongs_to :book

  def self.search(search, page)
    paginate :per_page => 20, :page => page,
           :conditions => ['text like ?', "%#{search}%"]
  end


end
