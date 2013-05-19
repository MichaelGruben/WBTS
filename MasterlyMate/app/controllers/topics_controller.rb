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

# This controller handles all managing actions of the topic model for authorized users.
# Therefore all actions can't be accessed by a guest user.
# All used breadcrumbs will be initialized in each action.
class TopicsController < ApplicationController
  load_and_authorize_resource
  
  # This action will load all available topics ordered by their name.
  # The loaded topics will then be rendered back to the requestor 
  # as html (according to the index view) and json format.
  def index
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    add_breadcrumb I18n.t("activerecord.models.topicPlural"), topics_path
    @topics = Topic.order("name").all

    respond_to do |format|
      format.html
      format.json { render json: @topics }
    end
  end

  # This action will load the displaying topic.
  # It will render the loaded topic together with the show view back to
  # the requestor as html. The loaded topic will also returned as json format.
  def show
    @topic = Topic.find(params[:id])
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    add_breadcrumb I18n.t("activerecord.models.topicPlural"), topics_path
    
    if !@topic.topic.nil?
      add_breadcrumb @topic.topic.name, @topic.topic
    end
    add_breadcrumb @topic.name, @topic

    respond_to do |format|
      format.html
      format.json { render json: @topic }
    end
  end

  # This action will prepare the updating process.
  # It is loading the updating topic.
  # Also it will provide the edit view, which is displaying the
  # topic form.
  def edit
    @topic = Topic.find(params[:id])
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    add_breadcrumb I18n.t("activerecord.models.topicPlural"), topics_path
    add_breadcrumb @topic.name, @topic
    add_breadcrumb t("topic.manage"), edit_topic_path(@topic)
  end
  
  # This action is responsible for updating a specified topic.
  # It will render the updating result as html and json format.
  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to @topic, notice: t("update.successful") }
        format.json { head :no_content }
      else
        format.html { render action: "edit", error: t("update.failed") }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # This action is responsible for creating a new topic.
  # It will render the creation result as html and json format.
  def create
    @topic = Topic.new(params[:topic])
    
    respond_to do |format|
      if @topic.save
        format.html { redirect_to topics_path, notice: "#{t("activerecord.models.topic")}#{t("create.successful")}" }
        format.json { render json: @topic, status: :created, location: @topic }
      else
        format.html { render action: "new", error: "#{t("activerecord.models.topic")}#{t("create.failed")}" }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # This action will prepare the creation process.
  # It is creating a new and empty topic.
  # Also it will provide the empty topic form.
  def new
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    add_breadcrumb I18n.t("activerecord.models.topicPlural"), topics_path
    add_breadcrumb I18n.t("topic.new"), new_topic_path
    @topic = Topic.new

    respond_to do |format|
      format.html
      format.json { render json: @topic }
    end
  end

  # This action handles the destroying process of a specified topic.
  # It will also render the destroying result back to the requestor as html and json format.
  def destroy
    @topic = Topic.find(params[:id])
    
    respond_to do |format|
      if @topic.destroy
        format.html { redirect_to topics_path, notice: "#{t("activerecord.models.topic")}#{t("destroy.successful")}" }
        format.json { head :no_content }
      else
        format.html { render action: "destroy", error: "#{t("activerecord.models.topic")}#{t("destroy.failed")}" }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
