class SessionsController < ApplicationController

  skip_filter :authenticate, :only => [:new, :create]

  def new
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Session terminated"
    redirect_to :action => "new"
  end

  def create
    name = params[:name]
    password = params[:password]

    session[:user_id] = User.find_by_name_and_password(name, password)
    
    if session[:user_id]
      redirect_to_return
    else
      flash[:error] = "User's name or password incorrect"
      redirect_to :action => "new"
    end
  end

end
