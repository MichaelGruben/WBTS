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

class TestobjectsController < ApplicationController
  # GET /testobjects
  # GET /testobjects.json
  def index
    @testobjects = Testobject.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @testobjects }
    end
  end

  # GET /testobjects/1
  # GET /testobjects/1.json
  def show
    @testobject = Testobject.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @testobject }
    end
  end

  # GET /testobjects/new
  # GET /testobjects/new.json
  def new
    @testobject = Testobject.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @testobject }
    end
  end

  # GET /testobjects/1/edit
  def edit
    @testobject = Testobject.find(params[:id])
  end

  # POST /testobjects
  # POST /testobjects.json
  def create
    @testobject = Testobject.new(params[:testobject])

    respond_to do |format|
      if @testobject.save
        format.html { redirect_to @testobject, notice: 'Testobject was successfully created.' }
        format.json { render json: @testobject, status: :created, location: @testobject }
      else
        format.html { render action: "new" }
        format.json { render json: @testobject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /testobjects/1
  # PUT /testobjects/1.json
  def update
    @testobject = Testobject.find(params[:id])

    respond_to do |format|
      if @testobject.update_attributes(params[:testobject])
        format.html { redirect_to @testobject, notice: 'Testobject was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @testobject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /testobjects/1
  # DELETE /testobjects/1.json
  def destroy
    @testobject = Testobject.find(params[:id])
    @testobject.destroy

    respond_to do |format|
      format.html { redirect_to testobjects_url }
      format.json { head :no_content }
    end
  end
  
  def upload
  uploaded_io = params[:course][:file]
  File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'w') do |file|
    file.write(uploaded_io.read)
  end
end
end
