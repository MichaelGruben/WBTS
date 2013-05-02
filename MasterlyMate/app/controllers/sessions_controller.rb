class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by_username_none_case_sensitive(params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "#{t('login.successful')}, #{user.username}"
    else
      flash[:error] = t("login.failed")
      redirect_to "#{root_path}?failed=1"
      #if controller.send(:_layout).identifier.split('/').last.split('.').first == "backend"
      #  redirect_to admin_path
      #else
      #  redirect_to root_path
      #end
    end 
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: t("logout.successful")
  end
  
end
