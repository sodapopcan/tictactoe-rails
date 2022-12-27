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
    session[:id] = current_session.id

    game = Game.find(params[:id])

    respond_to do |format|
      if game.join(current_session)
        format.html { redirect_to game_path(game) }
      else
        flash[:warning] = game.errors.full_messages.first
        format.html { redirect_to games_path }
      end
    end
  end

  def move
    game = Game.find(params[:id])

    respond_to do |format|
      if game.move(current_session, params[:cell_index].to_i)
        winner = game.winner
        name =
          if winner == game.player_1
            "Player 1"
          elsif winner == game.player_2
            "Player 2"
          else
            nil
          end
        if winner
          flash[:warning] = "Game Over. #{name} wins"
        end
        format.html { redirect_to game_path(game) }
      else
        flash[:warning] = game.errors.full_messages.first
        format.html { redirect_to game_path(game) }
      end
    end
  end

  private

  def redirect_to_current_game
    redirect_to game_path(current_session.current_game) if current_session.current_game
  end
end
