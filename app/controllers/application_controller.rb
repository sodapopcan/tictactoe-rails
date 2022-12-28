class ApplicationController < ActionController::Base
  private

  helper_method def current_session
    @current_session ||= Session.find_by(id: session[:id]) || Session.create!
  end

  def render_flash
    render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
  end
end
