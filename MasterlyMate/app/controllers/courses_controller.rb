class CoursesController < ApplicationController
  
  def start
  @course = Course.find(params[:id])
  @site = "/upload/"+@course.pathToFile+"/"+@course.mainFile
  #redirect_to @site
  end
  
  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @course = Course.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    @course = Course.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(params[:course])
    
    upload
    #if(!upload)
    #  redirect_to new_course_path, notice: "Kein valides SCORM-File"
    #else
    
    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render json: @course, status: :created, location: @course }
      else
        format.html { render action: "new" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end #end
  end
  
  def upload
    #Uploadroutine
    @course.pathToFile = params[:course][:pathToFile].original_filename
    @course.mainFile=params[:course][:mainFile]
    
    #returnVal=true
    directory = "public/upload"
    ## create the file path
    path = File.join(directory, @course.pathToFile)
    ## write the file
    File.open(path, "wb") { |f| f.write(params[:course][:pathToFile].read) }
    
    begin
    package = Scorm::Package.open(path, {repository: "#{directory}", cleanup: false}){|var|}
    rescue
     # returnVal=false
    end
    File.delete(path)
    #returnVal
    @course.pathToFile=package.name
    @course.mainFile=package.manifest.resources[0].href
  end

  # PUT /courses/1
  # PUT /courses/1.json
  
  
  def update
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course = Course.find(params[:id])
    @course.destroy
    FileUtils.rm_rf("public/upload/"+@course[:pathToFile])

    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :no_content }
    end 
  end
end
