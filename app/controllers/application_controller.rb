# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  filter_parameter_logging :password
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  include SimplestAuth::Controller

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  def index
    render :layout => 'default', :template =>'user_agents/index'
  end
  
  def new_session_url
    url_for :controller => "sessions", :action => "new" 
  end

end
