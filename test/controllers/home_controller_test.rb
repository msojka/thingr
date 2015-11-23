# require 'test_helper'
# 
# class HomeIntegrationTest < Capybara::Rails::TestCase
#   it do
#     Thing.delete_all
# 
#     Thing::Create.(thing: {name: "Trailblazer"})
#     Thing::Create.(thing: {name: "Rails"})
# 
#     visit "/"
# 
#     page.must_have_css ".columns .header a", text: "Rails" # TODO: test not-end.
#     page.must_have_css ".columns.end .header a", text: "Trailblazer"
#   end
# end