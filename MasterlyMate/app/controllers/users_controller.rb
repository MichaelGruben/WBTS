class UsersController < ApplicationController
  layout "frontend"
  
  def index
    #redirect_to new_user_path
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end
  
  def new
    initBreadcrumb
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
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
  
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: t("update.successful") }
        format.json { head :no_content }
      else
        format.html { render action: "edit", error: t("update.failed") }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    
    respond_to do |format|
      if @user.destroy
        format.html { redirect_to flights_url, notice: "#{t(activerecord.models.user)}#{t(destroy.successful)}" }
        format.json { head :no_content }
      else
        format.html { redirect_to flights_url, error: "#{t(activerecord.models.user)}#{t(destroy.failed)}" }
        format.json { head :no_content }
      end
    end
  end
  
  private
  def initBreadcrumb
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    add_breadcrumb I18n.t("page.breadcrumb.registration"), :new_user_path
  end
  
end
