module SessionHelper

#Log in the given user
  def login(user)
    session[:user_id] = user.id
  end
# Returns the user 
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
# Returns true if the user logged in
  def logged_in?
    !current_user.nil?
  end
# Logs out the current user
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end       
end
