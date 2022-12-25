class ApplicationController < ActionController::Base
  private

  def current_session
    @current_session ||=
      begin
        current_session = Session.find_by(id: session[:id])

        unless current_session
          current_session = Session.create
          session[:id] = current_session.id
        end

        current_session
      end
  end
end
