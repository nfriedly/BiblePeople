class PeopleController < ApplicationController
    before_filter :login_required, :except  => [:index, :show]
  
  # GET /people
  # GET /people.xml
  def index
    @people = Person.all
    
    respond_to do |format|
      format.html { render :layout => "main" } # index.html.erb
      format.xml  { render :xml => @people }
    end
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    @person = Person.find(params[:id])
    @siblings = Person.findSiblings(@person)

    respond_to do |format|
      format.html { render :layout => "main" } # show.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Person.new
    @person.names.new
    
    respond_to do |format|
      format.html { render :layout => "main" } # new.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
    render :layout => "main"
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])
    
    #save name(s)
    #params[:name].each {|name| 
    #  @name = Name.new
    #  @name.name = name
    #  @name.person_id = @person.id
    #  @name.save
    #}

    respond_to do |format|
      if @person.save
        flash[:notice] = 'Person was successfully created.'
        format.html { redirect_to(@person) }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new", :layout => "main" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = Person.find(params[:id])

    respond_to do |format|
      if @person.update_attributes(params[:person])
        flash[:notice] = 'Person was successfully updated.'
        format.html { redirect_to(@person) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit", :layout => "main"  }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
    end
  end
  
  # GET /people/parent
  # GET /people/parent.json
  # GET /people/parent.xml
  def parent
    if(params[:q] && !params[:name])
      params[:name] = params[:q]
    end

    @people = Name.suggestParent(params[:child], params[:which], params[:name])
    
    respond_to do |format|
      format.html { render :inline => "<% @people.each do |p| %><%= p.name %>|<%= p.person_id %>\n<% end %>"  } 
      format.json { render :json => @people }
      format.xml  { render :xml => @people }
    end
  end
  
  def verses
    if(params[:q] && !params[:name])
      params[:name] = params[:q]
    end
    
    @name = params[:name]
    @page = params[:page] || 1
    @type = (@page == "all") ? :all : :paged

    @verses = Verse.searchName(@name, @type, @page)
    
    respond_to do |format|
      format.html { render :layout => false } 
      format.json { render :json => @verses }
      format.xml  { render :xml => @verses }
    end
  end
  
end
