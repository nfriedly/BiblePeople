class PersonVersesController < ApplicationController
  before_filter :login_required
    
  # GET /person_verses
  # GET /person_verses.xml
  def index
    @person_verses = PersonVerse.all

    respond_to do |format|
      format.html { render :layout => "main" } # index.html.erb
      format.xml  { render :xml => @person_verses }
    end
  end

  # GET /person_verses/1
  # GET /person_verses/1.xml
  def show
    @person_verse = PersonVerse.find(params[:id])

    respond_to do |format|
      format.html  { render :layout => "main" } # show.html.erb
      format.xml  { render :xml => @person_verse }
    end
  end

  # GET /person_verses/new
  # GET /person_verses/new.xml
  def new
    @person_verse = PersonVerse.new

    respond_to do |format|
      format.html  { render :layout => "main" } # new.html.erb
      format.xml  { render :xml => @person_verse }
    end
  end

  # GET /person_verses/1/edit
  def edit
    @person_verse = PersonVerse.find(params[:id])
  end

  # POST /person_verses
  # POST /person_verses.xml
  def create
    @person_verse = PersonVerse.new(params[:person_verse])

    respond_to do |format|
      if @person_verse.save
        flash[:notice] = 'PersonVerse was successfully created.'
        format.html { redirect_to(@person_verse) }
        format.xml  { render :xml => @person_verse, :status => :created, :location => @person_verse }
      else
        format.html { render :action => "new",  :layout => "main" }
        format.xml  { render :xml => @person_verse.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /person_verses/1
  # PUT /person_verses/1.xml
  def update
    @person_verse = PersonVerse.find(params[:id])

    respond_to do |format|
      if @person_verse.update_attributes(params[:person_verse])
        flash[:notice] = 'PersonVerse was successfully updated.'
        format.html { redirect_to(@person_verse) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit", :layout => "main" }
        format.xml  { render :xml => @person_verse.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /person_verses/1
  # DELETE /person_verses/1.xml
  def destroy
    @person_verse = PersonVerse.find(params[:id])
    @person_verse.destroy

    respond_to do |format|
      format.html { redirect_to(person_verses_url) }
      format.xml  { head :ok }
    end
  end
end
