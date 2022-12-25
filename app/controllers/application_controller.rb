class ApplicationController < ActionController::Base
  private

  def current_session
    @current_session ||= Session.create_or_find_by(id: session[:id])
  end
end
