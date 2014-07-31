# This class loads stuff used in all other controllers.
#
# Author: Michael Woffendin 
# Copyright:

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :get_current_user, :except =>[:logout, :login, :authenticate]
  #rescue_from CanCan::AccessDenied, :with => :permission_denied
  #rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  #rescue_from ActionController::RoutingError, :with => :page_not_found
  helper_method :current_user
  
  
  def login
  end
  
  
  
  def authenticate
    @name = params[:name]
    @pass = params[:password]
    user = User.where("LOWER(users.name) = ? AND users.password = ?", @name.downcase, @pass).first
    if user
      session[:user_id] = user.id
      flash[:notice] = "Logged in as #{user.name}"
      redirect_to root_path
    else
      @failed = true
      flash[:error] = "Login failed"
      render :login
    end
  end
  


  # Destroys session and logs user out o
  def logout
    reset_session
    flash[:notice] = "Logged out"
    redirect_to :login
  end


  private
    # Returns the current user (required method for CanCan)
    def current_user
      return @current_user
    end
    
    
    # Loads the currently logged-in user. If the user in the session is blank or not in the
    # database, checks to see if application accepts open login. If so, creates a new user.
    # Otherwise destroys session.
    def get_current_user
      if session[:user_id].blank?
        redirect_to :login
      else
        @current_user = User.find(session[:user_id])
      end
    end


    # Logs an exception's contents, along with what page it was raised on.
    def log_error(exception, raised_on)
      current_user_string = ""
      current_user_string = (", User ID: " + @current_user.id.to_s) if @current_user
      logger.error "\n!!!!!!!!!!!!!!!!!! ERROR  BEGINS !!!!!!!!!!!!!!!!!!!!!!"
      logger.error exception
      logger.error ("Raised on: " + raised_on + current_user_string + "\n")
    end


    # Redirects user to 'invalid credentials' error page
    def invalid_credentials(exception)
      log_error(exception, request.fullpath)
      render "errors/invalid_credentials"
    end


    # Redirects user to 'permission denied' error page
    def permission_denied(exception)
      log_error(exception, request.fullpath)
      render "errors/permission_denied"
    end


    # Redirects user to 'page not found' error page
    def page_not_found(exception)
      log_error(exception, request.fullpath)
      render "errors/page_not_found"
    end


    # Redirects user to 'page not found' error page
    def record_not_found(exception)
      log_error(exception, request.fullpath)
      render "errors/record_not_found"
    end
end
