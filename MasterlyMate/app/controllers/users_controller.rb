#########################################################################
#Copyright 2013 Michael Gruben, Julian Babics, Benjamin Merkle
#
#This file is part of Masterly Mate.
#
#Masterly Mate is free software: you can redistribute it and/or modify it
#under the terms of the GNU Affero General Public License as published by
#the Free Software Foundation, either version 3 of the License, or (at
#your option) any later version.
#
#Masterly Mate is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU Affero General Public License for more details.
#
#You should have received a copy of the GNU Affero General Public License
#along with Masterly Mate.  If not, see <http://www.gnu.org/licenses/>.
#
#Diese Datei ist Teil von Masterly Mate.
#
#Masterly Mate ist Freie Software: Sie können es unter den Bedingungen
#der GNU Affero General Public License, wie von der Free Software
#Foundation, Version 3 der Lizenz oder (nach Ihrer Option) jeder späteren
#veröffentlichten Version, weiterverbreiten und/oder modifizieren.
#
#Masterly Mate wird in der Hoffnung, dass es nützlich sein wird, aber
#OHNE JEDE GEWÄHELEISTUNG, bereitgestellt; sogar ohne die implizite
#Gewährleistung der MARKTFÄHIGKEIT oder EIGNUNG FÜR EINEN BESTIMMTEN
#ZWECK.
#Siehe die GNU Affero General Public License für weitere Details.
#
#Sie sollten eine Kopie der GNU Affero General Public License zusammen
#mit Masterly Mate erhalten haben. Wenn nicht, siehe
#<http://www.gnu.org/licenses/>.
#########################################################################

# This controller handles all managing actions of the user model for authorized and guest users.
# All used breadcrumbs will be initialized in the desired actions.
# The actions for creating a new user corresponds to the registration process of a user.
# Therefore this actions shall be accessible by guest users.
class UsersController < ApplicationController
  load_and_authorize_resource except: [:new, :create]
  
  # All users will be loaded and rendered together with the index view as html
  # format back to the requestor by this action. The user collection is also rendered back 
  # as json format.
  def index
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    add_breadcrumb I18n.t("activerecord.models.userPlural"), :users_path
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end
  
  # This action will initiate and prepare the registration process of a guest user.
  # It will create a new and empty user instance and render the registration form as html format.
  def new
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    add_breadcrumb I18n.t("page.breadcrumb.registration"), :new_user_path
    @user = User.new
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end
  
  # This action will persist the new user in the database.
  # After successful saving the requestor will be redirected to the start page.
  # Otherwise the user will get on the registration page an error message.
  def create
    @user = User.new(params[:user])
    defaultGroup = Group.where("name = 'Registered'").first
    defaultGroup.users << @user
    defaultGroup.save
    if @user.save
      redirect_to root_path, notice: t("register.successful")
    else
      flash[:error] = t("register.failed")
      render "new"
    end
  end
  
  # This action will load and display with the corresponding view the specified user 
  # back to the requestor as html format. This controller provides also the access
  # to the specified user via json format.
  def show
    @user = User.find(params[:id])
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    if can? :read, User
      add_breadcrumb I18n.t("activerecord.models.userPlural"), :users_path
    end
    add_breadcrumb @user.username, @user
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end
  
  # This action will initiate and prepare the updating process of a registered user.
  # It will load the specified user instance and render the update form as html format.
  def edit
    @user = User.find(params[:id])
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    if can? :read, User
      add_breadcrumb I18n.t("activerecord.models.userPlural"), :users_path
    end
    add_breadcrumb @user.username, @user
    add_breadcrumb t("profile.manage"), edit_user_path(@user)
  end
  
  # This action will persist the changes of the selected user in the database.
  # After successful saving the requestor will be redirected to show view.
  # Otherwise the user will get on the edit page an error message.
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

  # This action will remove the selected user from the database.
  # After successful removing the requestor will be redirected to the index view, which will display
  # a list of all registered users. Otherwise the user will get on the same page an error message.
  def destroy
    @user = User.find(params[:id])
    
    respond_to do |format|
      if @user.destroy
        format.html { redirect_to users_path, notice: "#{t("activerecord.models.user")}#{t("destroy.successful")}" }
        format.json { head :no_content }
      else
        format.html { render action: "destroy", error: "#{t("activerecord.models.user")}#{t("destroy.failed")}" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # This method is only a helper action. It handles an AJAX request if the rendered page
  # contains progressbars. If so, all progressbars will be initialized on client side according to 
  # the initProgressbars.js.erb file.
  def initProgressbars
    @user = User.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
  
  include UsersHelper
  # This action will load the specified user and render the statistic view back as html format.
  # The statistic contains up to now informations about the whole points of the selected user,
  # the average rank and the progress of each assessment.
  def statistic
    @user = User.find(params[:id])
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    if can? :read, User
      add_breadcrumb I18n.t("activerecord.models.userPlural"), :users_path
    end
    add_breadcrumb @user.username, @user
    add_breadcrumb t("profile.statistic.title"), user_statistic_link(@user)
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end
  
  # This method is only a helper action. It handles an AJAX request of the current exam using the corresponding WBT. 
  # Up to now the user has to review himself. So he has to define if he has succeeded the current exam or not.
  # Depending on his decision, the points of the current exam will be updated.
  # The reached points for the depending assessment will also be updated.
  def updateExam
    assessment = Assessment.find(params[:assessment])
    exam = Exam.find(params[:exam])
    wbt = Wbt.find(params[:wbt])
    increasePoints = params[:increase]
    
    if increasePoints == "true"
      exam.points = wbt.getDifficultyPoints
    else
      exam.points = 0
    end
    exam.save
    assessment.points = assessment.exams.sum("points")
    assessment.save
    
    respond_to do |format|
      format.js
    end
  end
  
end
