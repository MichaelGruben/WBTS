class TopicsController < ApplicationController
  # GET /wbts
  # GET /wbts.json
  def index
    @topics = Topic.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @topics }
    end
  end

  # GET /wbts/1
  # GET /wbts/1.json
  def show
    @topic = Topic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @topic }
    end
  end

  # GET /wbts/new
  # GET /wbts/new.json
  def new
    @topic = Topic.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @topic }
    end
  end

  # GET /wbts/1/edit
  def edit
    @topic = Topic.find(params[:id])
  end

  # POST /wbts
  # POST /wbts.json
  def create
    @topic = Topic.new(params[:topic])
    
    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: 'topic was successfully created.' }
        format.json { render json: @topic, status: :created, location: @topic }
      else
        format.html { render action: "new" }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end #end
  end

  # PUT /wbts/1
  # PUT /wbts/1.json
  

  # DELETE /wbts/1
  # DELETE /wbts/1.json
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    #FileUtils.rm_rf("public/upload/"+@topic[:file])

    respond_to do |format|
      format.html { redirect_to topics_url }
      format.json { head :no_content }
    end 
  end

  
end
