class UsersController < ApplicationController
  layout "frontend"
  
  def index
    redirect_to new_user_path
  end
  
  def new
    initBreadcrumb
    @user = User.new
  end
  
  def create
    initBreadcrumb
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_path, notice: t("register.successful")
    else
      render "new"
    end
  end
  
  private
  def initBreadcrumb
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    add_breadcrumb I18n.t("page.breadcrumb.registration"), :new_user_path
  end
  
end
