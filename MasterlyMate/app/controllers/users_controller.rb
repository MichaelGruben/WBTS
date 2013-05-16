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

class UsersController < ApplicationController
  load_and_authorize_resource except: [:new, :create]
  
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
    defaultGroup = Group.where("name = 'Registered'").first
    defaultGroup.users << @user
    defaultGroup.save
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
        format.html { redirect_to "/#{params[:locale]}/users/#{@user.id}/", notice: t("update.successful") }
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
        format.html { redirect_to "/#{params[:locale]}/users/#{@user.id}/", notice: "#{t(activerecord.models.user)}#{t(destroy.successful)}" }
        format.json { head :no_content }
      else
        format.html { render action: "destroy", error: "#{t(activerecord.models.user)}#{t(destroy.failed)}" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  def initBreadcrumb
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    add_breadcrumb I18n.t("page.breadcrumb.registration"), :new_user_path
  end
  
end
