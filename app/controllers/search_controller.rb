class SearchController < ApplicationController

  def index
    if(!params[:page]) 
	redirectUrl = Search.keyword(params[:q])
	redirect_to redirectUrl if redirectUrl
    end
    @verses = Search.search(params[:q], params[:page])
    @terms = Search.terms
    @refference = Search.refference
    render :layout => 'main'
  end

end
