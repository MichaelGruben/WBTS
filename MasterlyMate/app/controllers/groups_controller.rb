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

# This controller provides actions to the group model like updating or displaying a group.
# In the current version of Masterly Mate there are only two available groups called
# Administrator and Registered. All actions can't be accessed by a guest user.
# All used breadcrumbs will be initialized in each action.
class GroupsController < ApplicationController
  load_and_authorize_resource
  
  # This action will load all available groups.
  # The loaded groups will then be rendered back to the requestor as html and json format.
  # This action 
  def index
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    add_breadcrumb I18n.t("activerecord.models.groupPlural"), :groups_path
    @groups = Group.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end
  
  # The specified group will be loaded by this action.
  # It will also render the loaded group together with the corresponding view as
  # html and json format back to the requestor.
  def show
    @group = Group.find(params[:id])
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    add_breadcrumb I18n.t("activerecord.models.groupPlural"), :groups_path
    add_breadcrumb @group.name, @group

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end
  
  # The specified group will be loaded by this action.
  # Furthermore this action prepare the updating process.
  def edit
    @group = Group.find(params[:id])
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    add_breadcrumb I18n.t("activerecord.models.groupPlural"), :groups_path
    add_breadcrumb @group.name, @group
    add_breadcrumb t("group.manage"), edit_group_path(@group)
  end
  
  # The changes of the specified group will be persist in this action.
  # It will also return a rendered html and json format back to the requestor.
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to groups_path, notice: t("update.successful") }
        format.json { head :no_content }
      else
        format.html { render action: "edit", error: t("update.failed") }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
