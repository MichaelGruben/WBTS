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

# This controller handles all managing actions of a WBT.
# All used breadcrumbs will be initialized in the desired actions.
# This controller is using up to now for all actions except the start and the updateExam actions the default layout.
# This controller handles also the start action of the selected WBT, which will execute it.
class WbtsController < ApplicationController
  layout "frontend", except: [:start, :updateExam]
  load_and_authorize_resource
  
  include SessionsHelper
  # This action is responsible for executing the desired WBT.
  # It will check if the user already has a assessment of this topic.
  # If not this action will create a new assessment according to this topic and it
  # will assign it to the current user. The same will be done by the exams of the assessment.
  # After this initialization process the user will be redirected to a new browser tab, which 
  # is displaying the main entry page of the WBT.
  def start
    @wbt = Wbt.find(params[:id])
    @site = "/upload/"+@wbt.file+"/"+@wbt.mainFile
    assessment = current_user.assessments.where("topic_id = ?", params[:topic])
    if assessment.count <= 0
      newExam = Exam.new
      newExam.wbt_id = @wbt.id
      newExam.points = 0
      newExam.save
      @exam = newExam
      newAssessment = Assessment.new
      newAssessment.topic = Topic.find(params[:topic])
      newAssessment.rank_id = 1
      newAssessment.points = 0
      newAssessment.exams << newExam
      newAssessment.save
      @assessment = newAssessment
      current_user.assessments << newAssessment
      current_user.save
    else
      currentAssessment = assessment.first
      @assessment = currentAssessment
      exam = currentAssessment.exams.where("wbt_id = ?", @wbt.id)
      if exam.count <= 0
        newExam = Exam.new
        newExam.wbt_id = @wbt.id
        newExam.points = 0
        newExam.save
        @exam = newExam
        currentAssessment.exams << newExam
        currentAssessment.save
      else
        currentExam = exam.first
        @exam = currentExam
      end
    end
  end

  # This action will load all available WBTs and render them as html with the corresponding index view
  # back to the requestor. The WBTs can also be accessed via json format.
  def index
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    add_breadcrumb I18n.t("activerecord.models.wbtPlural"), wbts_path
    @wbts = Wbt.all

    respond_to do |format|
      format.html
      format.json { render json: @wbts }
    end
  end

  # The action will load the selected WBT and display it's detailed information
  # with the corresponding show view.
  def show
    @wbt = Wbt.find(params[:id])
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    add_breadcrumb I18n.t("activerecord.models.wbtPlural"), wbts_path
    add_breadcrumb @wbt.name, @wbt

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wbt }
    end
  end

  # This action will initiate and prepare the creation process of a new WBT.
  # It will create a new and empty WBT instance and render the empty edit form as html format.
  def new
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    add_breadcrumb I18n.t("activerecord.models.wbtPlural"), wbts_path
    add_breadcrumb t("wbt.new"), new_wbt_path
    @wbt = Wbt.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @wbt }
    end
  end

  # This action will initiate and prepare the updating process of a WBT.
  # It will load the specified WBT instance and render the update form as html format.
  def edit
    @wbt = Wbt.find(params[:id])
    add_breadcrumb I18n.t("page.breadcrumb.start"), :root_path
    add_breadcrumb I18n.t("activerecord.models.wbtPlural"), wbts_path
    add_breadcrumb @wbt.name, @wbt
    add_breadcrumb t("wbt.manage"), edit_wbt_path(@wbt)
  end

  # This action will persist the new WBT instance in the database.
  # After successful saving the requestor will be redirected to index view, which is displaying a list of all WBTs.
  # Otherwise the user will get on the same page an error message.
  # This action will also copy the uploaded and temporary on the server saved WBT folder to 
  # the public directory.
  def create
    @wbt = Wbt.new(params[:wbt])
    
    if defined? params[:wbt][:file].original_filename and FileTest.exists?("public/upload/#{params[:wbt][:file].original_filename}")
      existingWbt = Wbt.where("file = ?", params[:wbt][:file].original_filename).first
      if !existingWbt.nil?
        @wbt.file = existingWbt.file
        @wbt.mainFile = existingWbt.mainFile
      end
    else
      upload
    end
    
    respond_to do |format|
      if @wbt.save
        @wbt.topics.each do |topic|
          assignWbtToSubTopics(topic, @wbt)
        end
        format.html { redirect_to wbts_path, notice: "WBT #{t("create.successful")}" }
        format.json { render json: @wbt, status: :created, location: @wbt }
      else
        format.html { render action: "new", error: "WBT #{t("create.failed")}" }
        format.json { render json: @wbt.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # This action will persist the changes made of the selected WBT in the database.
  # After successful saving the requestor will be redirected to the show view.
  # Otherwise the user will get on the edit page an error message.
  def update
    @wbt = Wbt.find(params[:id])

    respond_to do |format|
      if @wbt.update_attributes(params[:wbt])
        @wbt.topics.each do |topic|
          assignWbtToSubTopics(topic, @wbt)
        end
        format.html { redirect_to @wbt, notice: t("update.successful") }
        format.json { head :no_content }
      else
        format.html { render action: "edit", error: t("update.failed") }
        format.json { render json: @wbt.errors, status: :unprocessable_entity }
      end
    end
  end

  # This action will remove the selected WBT from the database.
  # After successful removing the requestor will be redirected to the index view, which will display
  # a list of all available WBTs. Otherwise the user will get on the same page an error message.
  # This action will also remove the whole folder for the WBT from the public directory.
  def destroy
    @wbt = Wbt.find(params[:id])
    @wbt.destroy
    FileUtils.rm_rf("public/upload/"+@wbt[:file])
    
    respond_to do |format|
      if @wbt.destroy
        format.html { redirect_to :back, notice: "WBT #{t("destroy.successful")}" }
        format.json { head :no_content }
      else
        format.html { render action: "destroy", error: "WBT #{t("destroy.failed")}" }
        format.json { render json: @wbt.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  def upload
    if defined? params[:wbt][:file].original_filename
      @wbt.file = params[:wbt][:file].original_filename
      @wbt.mainFile=params[:wbt][:mainFile]
    
      #returnVal=true
      directory = "public/upload"
      ## create the file path
      path = File.join(directory, @wbt.file)
      ## write the file
      File.open(path, "wb") { |f| f.write(params[:wbt][:file].read) }
    
      begin
        package = Scorm::Package.open(path, {repository: "#{directory}", cleanup: false}){|var|}
      rescue
        # returnVal=false
      end
      File.delete(path)
      #returnVal
      @wbt.file=package.name
      @wbt.mainFile=package.manifest.resources[0].href
    end
  end
  
  def assignWbtToSubTopics(topic, wbt)
    begin
      assignWbtToTopic(topic, wbt)
      if topic.topics.count > 0
        topic.topics.each do |subtopic|
          assignWbtToSubTopics(subtopic, wbt)
        end
      end
    rescue => exception
      logger.error("error occurred while assigning wbt to subtopics. #{exception.message}")
    end
  end
  
  def assignWbtToTopic(topic, wbt)
    if !topic.wbts.include? wbt
      topic.wbts << wbt
      topic.save
    end
  end
  
end
