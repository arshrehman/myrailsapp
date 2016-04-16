class SessionController < ApplicationController
 
  def new
  end
  
  #log in the user
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      login user
      redirect_to user
    else
       flash.now[:danger] = 'invalid email/password combination'
       render 'new'
    end
  end   
  #log out the user
  def destroy
    log_out
    redirect_to root_url
  end    
end
