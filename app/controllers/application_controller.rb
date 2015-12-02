class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  include Trailblazer::Operation::Controller
  
  def tyrant
    Tyrant::Session.new(request.env['warden'])
  end
  helper_method :tyrant
end
