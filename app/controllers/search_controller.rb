class SearchController < ApplicationController

  def index
    @verses = Search.search(params[:q], params[:page])
    @terms = Search.terms
    @refference = Search.refference
    render :layout => 'main'
  end

end
