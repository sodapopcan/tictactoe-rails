class ApplicationController < ActionController::Base
  private

  def current_session
    @current_session ||= Session.find_by(id: session[:id]) || Session.create!
  end
end
