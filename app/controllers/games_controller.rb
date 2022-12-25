class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])
  end

  def create
    game = Game.create(player_1: current_session)

    respond_to do |format|
      format.html { redirect_to game_path(game) }
    end
  end
end
