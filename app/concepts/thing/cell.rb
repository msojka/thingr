class Thing::Cell < Cell::Concept
  property :name
  property :description
  property :created_at
  
  include ActionView::Helpers::DateHelper
  
  include Cell::GridCell
  self.classes = ["thing", "large-3", "columns"]
  
  include Cell::CreatedAt
  
  def show
    render
  end
  
private
  def name_link
    link_to name, thing_path(model)
  end
  
  class Grid < Cell::Concept
    include Cell::Caching::Notifications
    cache :show do
      CacheVersion.for("things/cell/grid")
    end
    
    def show
      things = Thing.latest
      concept("thing/cell", collection: things, last: things.last)
    end
  end
  
end