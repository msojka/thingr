ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# require "minitest/rails"
# require "minitest/rails/capybara" # loads Capybara, etc.

require "pp"

Rails.backtrace_cleaner.remove_silencers!

MiniTest::Spec.class_eval do
  after :each do
    # DatabaseCleaner.clean
    Thing.delete_all
    Comment.delete_all
    User.delete_all
    Authorship.delete_all
  end
end

# Cell::TestCase.class_eval do
#   include Capybara::DSL
#   include Capybara::Assertions
# end
# 
# class IntegrationTest < Capybara::Rails::TestCase
#   def sign_in!(*)
#     sign_up! #=> Session::SignUp
# 
#     visit "/sessions/sign_in_form"
# 
#     submit!(email="fred@trb.org", password="123456")
#   end
# 
#   def sign_up!(email="fred@trb.org", password="123456")
#     Session::SignUp::Admin.(user: {email: email, password: password})
#   end
# 
#   def submit!(email, password)
#     within("//form[@id='new_session']") do
#       fill_in 'Email',    with: email
#       fill_in 'Password', with: password
#     end
#     click_button "Sign in!"
#   end
# end