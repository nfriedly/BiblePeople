class SearchController < ApplicationController

  def index
    @verses = Verse.search(params[:q], params[:page])
  end

end
