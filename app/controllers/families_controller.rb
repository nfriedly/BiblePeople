class FamiliesController < ApplicationController
  
  def index
    show
  end

  def show 
    params[:max_depth] ||= 10
    @max_depth = (params[:max_depth] > 100) ? 100 : params[:max_depth]
    @parent = (params[:id]) ? Person.find(params[:id]) : Person.find(:first)
    render :layout => "main", :template => "families/show.html"
  end
  
end
