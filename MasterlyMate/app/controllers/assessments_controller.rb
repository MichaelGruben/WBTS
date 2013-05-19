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

# This controller contains actions for displaying all assessments, or one 
# single assessment. This controller also handles the destroying process of one assessment.
# All used breadcrumbs will be initialized in each action.
class AssessmentsController < ApplicationController
  
  include SessionsHelper
  # This action will load all assessments if the current user is an Administrator.
  # Otherwise the current user's assessments will be loaded.
  # The loaded assessments will then be displayed in the index view and returned as html.
  def index
    @user = current_user
    if @user.group? "Administrator"
      @assessments = Assessment.all
    else
      @assessments = @user.assessments
    end
    
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    add_breadcrumb @user.username, @user
    add_breadcrumb "Assessments", user_assessments_path(@user)
    
    respond_to do |format|
      format.html
    end
  end
  
  # This action will load the specified assessment.
  # The loaded assessment will then be displayed in the show view and returned as html.
  def show
    @assessment = Assessment.find(params[:id])
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    add_breadcrumb @assessment.user.username, @assessment.user
    add_breadcrumb "Assessments", "/#{params[:locale]}/users/#{@assessment.user.id}/assessments"
    add_breadcrumb @assessment.topic.name, "/#{params[:locale]}/users/#{@assessment.user.id}/assessments/#{@assessment.id}"
    respond_to do |format|
      format.html
    end
  end
  
  # This action handles the destroying process of the specified assessment.
  # It returns a rendered html format and a rendered json format.
  def destroy
    @assessment = Assessment.find(params[:id])
    user = @assessment.user
    
    respond_to do |format|
      if @assessment.destroy
        format.html { redirect_to user_assessments_path(user), notice: "Assessment#{t("destroy.successful")}" }
        format.json { head :no_content }
      else
        format.html { render action: "destroy", error: "Assessment#{t("destroy.failed")}" }
        format.json { render json: @assessment.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
