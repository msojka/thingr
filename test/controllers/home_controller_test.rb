require 'test_helper'

class HomeIntegrationTest < ActionDispatch::IntegrationTest
  it do
    Thing::Create.(thing: {name: "Rails"})
    # "Smoke" test .. just make sure that Thing grid cell is included.
    get "/"
    assert_select ".header a", text: "Rails"
  end
end