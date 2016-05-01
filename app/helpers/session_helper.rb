module SessionHelper

#Log in the given user
  def login(user)
    session[:user_id] = user.id
  end
  #Remembers the user in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  #Identify the current user
  def current_user?(user)
    user == current_user
  end
  
  #Returns the user corresponding to the remember token
  def create
    if (user_id = session[:user_id])
      @current_user = User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        login user
        @current_user = user
      end
    end
  end      
# Returns the user 
  def current_user
    if(user_id = session[:user_id])
      @current_user ||= User.find_by(id: [user_id])
    elsif(user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        login user
        @current_user = user
      end
    end     
  end
# Returns true if the user logged in
  def logged_in?
    !current_user.nil?
  end
# Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
# Logs out the current user
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  #Redirects to the stored location(or to the default)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  #Stores the location trying to be accessed
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end    
         
end
