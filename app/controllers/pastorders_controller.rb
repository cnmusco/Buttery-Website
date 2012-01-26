class PastordersController < ApplicationController
  # GET /pastorders
  # GET /pastorders.xml
  def index
    @pastorders = Pastorder.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pastorders }
    end
  end

  # GET /pastorders/1
  # GET /pastorders/1.xml
  def show
    @pastorder = Pastorder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pastorder }
    end
  end

  # GET /pastorders/new
  # GET /pastorders/new.xml
  def new
    @pastorder = Pastorder.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pastorder }
    end
  end

  # GET /pastorders/1/edit
  def edit
    @pastorder = Pastorder.find(params[:id])
  end

  # POST /pastorders
  # POST /pastorders.xml
  def create
    @pastorder = Pastorder.new(params[:pastorder])

    respond_to do |format|
      if @pastorder.save
        format.html { redirect_to(@pastorder, :notice => 'Pastorder was successfully created.') }
        format.xml  { render :xml => @pastorder, :status => :created, :location => @pastorder }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pastorder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pastorders/1
  # PUT /pastorders/1.xml
  def update
    @pastorder = Pastorder.find(params[:id])

    respond_to do |format|
      if @pastorder.update_attributes(params[:pastorder])
        format.html { redirect_to(@pastorder, :notice => 'Pastorder was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pastorder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pastorders/1
  # DELETE /pastorders/1.xml
  def destroy
    @pastorder = Pastorder.find(params[:id])
    @pastorder.destroy

    respond_to do |format|
      format.html { redirect_to(pastorders_url) }
      format.xml  { head :ok }
    end
  end
end
