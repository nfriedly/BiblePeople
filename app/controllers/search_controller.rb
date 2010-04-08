class SearchController < ApplicationController

  def index
    if(!params[:page]) 
      people = Name.findPeople(params[:q])
      redirect_to '/people/' + params[:q] if people.length
      return
    end
    @verses = Search.search(params[:q], params[:page])
    @terms = Search.terms
    @refference = Search.refference
    render :layout => 'main'
  end

end
