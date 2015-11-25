class Thing::Cell < Cell::Concept
  property :name
  property :created_at
  
  include ActionView::Helpers::DateHelper
  
  def show
    render
  end
  
private
  def name_link
    link_to name, thing_path(model)
  end
  
  def created_at
    time_ago_in_words(super)
  end
  
  def last_thing_class
    options[:last] == model ? 'end' : ''
  end
  
  class Grid < Cell::Concept
    def show
      things = Thing.latest
      concept("thing/cell", collection: things, last: things.last)
    end
  end
  
end