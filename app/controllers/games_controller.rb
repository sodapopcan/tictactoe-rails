class GamesController < ApplicationController
  before_action :redirect_to_current_game, only: [:index]

  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

  def create
    session[:id] = current_session.id

    game = Game.create!(player_1: current_session)

    respond_to do |format|
      format.html { redirect_to game_path(game) }
    end
  end

  def join
    game = Game.find(params[:id])

    game.update!(player_2: current_session)

    respond_to do |format|
      format.html { redirect_to game_path(game) }
    end
  end

  private

  def redirect_to_current_game
    redirect_to game_path(current_session.current_game) if current_session.current_game
  end
end
