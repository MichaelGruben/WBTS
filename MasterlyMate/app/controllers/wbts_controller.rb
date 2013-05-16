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

class WbtsController < ApplicationController
  layout "frontend", except: [:start]
  load_and_authorize_resource
  
  def start
  @wbt = Wbt.find(params[:id])
  @site = "/upload/"+@wbt.file+"/"+@wbt.mainFile
  #redirect_to @site
  end

  # GET /wbts
  # GET /wbts.json
  def index
    @wbts = Wbt.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @wbts }
    end
  end

  # GET /wbts/1
  # GET /wbts/1.json
  def show
    @wbt = Wbt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wbt }
    end
  end

  # GET /wbts/new
  # GET /wbts/new.json
  def new
    @wbt = Wbt.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @wbt }
    end
  end

  # GET /wbts/1/edit
  def edit
    @wbt = Wbt.find(params[:id])
  end

  # POST /wbts
  # POST /wbts.json
  def create
    @wbt = Wbt.new(params[:wbt])
    
    upload
    #if(!upload)
    #  redirect_to new_wbt_path, notice: "Kein valides SCORM-File"
    #else
    
    respond_to do |format|
      if @wbt.save
        format.html { redirect_to @wbt, notice: 'wbt was successfully created.' }
        format.json { render json: @wbt, status: :created, location: @wbt }
      else
        format.html { render action: "new" }
        format.json { render json: @wbt.errors, status: :unprocessable_entity }
      end
    end #end
  end
  
  def upload
    #Uploadroutine
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

  # PUT /wbts/1
  # PUT /wbts/1.json
  
  
  def update
    @wbt = Wbt.find(params[:id])

    respond_to do |format|
      if @wbt.update_attributes(params[:wbt])
        format.html { redirect_to @wbt, notice: 'wbt was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @wbt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wbts/1
  # DELETE /wbts/1.json
  def destroy
    @wbt = Wbt.find(params[:id])
    @wbt.destroy
    FileUtils.rm_rf("public/upload/"+@wbt[:file])

    respond_to do |format|
      format.html { redirect_to wbts_url }
      format.json { head :no_content }
    end 
  end
end
