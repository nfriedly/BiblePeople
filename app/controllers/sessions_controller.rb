class SessionsController < ApplicationController
  
  def index
    redirect_to new_session_url
  end

  
  
  # POST /sessions/create
  def create
    if user = User.authenticate(params[:email], params[:password])
      self.current_user = user
      #session[:user] = user
      flash[:notice] = 'Welcome!'
      redirect_to "/"
    else
      flash[:error] =  "Couldn't locate a user with those credentials"
      redirect_to new_session_url
    end
  end
  
  # GET /login
  # GET /sessions/new
  def new
    render :layout => "main" 
  end
  
  # DELETE /logout
  # DELETE /sessions/destroy
  def destroy 
      clear_session
      flash[:notice] = "You have been logged out.";
      redirect_to new_session_url
  end
end
