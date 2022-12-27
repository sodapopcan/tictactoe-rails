class ApplicationController < ActionController::Base
  private

  helper_method def current_session
    @current_session ||= Session.find_by(id: session[:id]) || Session.create!
  end
end
