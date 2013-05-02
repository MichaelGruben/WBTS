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
