class SearchController < ApplicationController

  def index
    if(!params[:page] && Name.isName(params[:q])) 
      redirect_to '/people/' + params[:q]
      return
    end
    @verses = Search.search(params[:q], params[:page])
    @terms = Search.terms
    @refference = Search.refference
    render :layout => 'main'
  end

end
