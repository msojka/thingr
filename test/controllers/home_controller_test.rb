require 'test_helper'

class HomeIntegrationTest < ActionDispatch::IntegrationTest
  it do
    Thing.delete_all
    Thing::Create.(thing: {name: "Rails"})
    # "Smoke" test .. just make sure that Thing grid cell is included.
    get "/"
    assert_select ".thing a", text: "Rails"
  end
end