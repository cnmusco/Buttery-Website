class MakeupsController < ApplicationController
  # GET /makeups
  # GET /makeups.xml
  def index
    @makeups = Makeup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @makeups }
    end
  end

  # GET /makeups/1
  # GET /makeups/1.xml
  def show
    @makeup = Makeup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @makeup }
    end
  end

  # GET /makeups/new
  # GET /makeups/new.xml
  def new
    @makeup = Makeup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @makeup }
    end
  end

  # GET /makeups/1/edit
  def edit
    @makeup = Makeup.find(params[:id])
  end

  # POST /makeups
  # POST /makeups.xml
  def create
    @makeup = Makeup.new(params[:makeup])

    respond_to do |format|
      if @makeup.save
        format.html { redirect_to(@makeup, :notice => 'Makeup was successfully created.') }
        format.xml  { render :xml => @makeup, :status => :created, :location => @makeup }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @makeup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /makeups/1
  # PUT /makeups/1.xml
  def update
    @makeup = Makeup.find(params[:id])

    respond_to do |format|
      if @makeup.update_attributes(params[:makeup])
        format.html { redirect_to(@makeup, :notice => 'Makeup was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @makeup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /makeups/1
  # DELETE /makeups/1.xml
  def destroy
    @makeup = Makeup.find(params[:id])
    @makeup.destroy

    respond_to do |format|
      format.html { redirect_to(makeups_url) }
      format.xml  { head :ok }
    end
  end
end
