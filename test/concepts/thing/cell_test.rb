require 'test_helper'

class ThingCellTest < Cell::TestCase
  controller ThingsController
  
  it do
    Thing::Create.(thing: { name: 'Rails' })
    Thing::Create.(thing: { name: 'Trailblazer' })
    
    html = concept("thing/cell/grid").()
    
    html.must_have_selector ".columns .header a", text: "Rails"
    html.wont_have_selector ".columns.end .header a", text: "Trailblazer"
    html.must_have_selector ".columns.end .header a", text: "Rails"
  end
end
  