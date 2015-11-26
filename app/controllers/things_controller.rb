class ThingsController < ApplicationController
  def show
    @thing = present(Thing::Update).model
    form Comment::Create
  end
  
  def new
    form Thing::Create
  end
  
  def create
    run Thing::Create do |op|
      return redirect_to op.model
    end
    render :new
  end
  
  def edit
    form Thing::Update
    render :new
  end
  
  def update
    run Thing::Update do |op|
      return redirect_to op.model
    end
    render :new
  end
  
  def create_comment
    present Thing::Update
    run Comment::Create do |op|
      flash[:notice] = "Created comment for #{op.thing.name}"
      return redirect_to thing_path(op.thing)
    end
    render :show
  end
  
  def next_comments
    @thing = present(Thing::Update).model
    render js: concept("comment/cell/grid", @thing, page: params[:page]).(:append)
  end
  
end
