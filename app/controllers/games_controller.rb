class GamesController < ApplicationController
  def index
    @games = Game.open
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
        format.turbo_stream
      else
        format.html { redirect_to games_path, flash: { warning: game.errors.full_messages.first } }
        format.turbo_stream do
          flash.now[:warning] = game.errors.full_messages.first
          render_flash
        end
      end
    end
  end

  def move
    game = Game.find(params[:id])

    respond_to do |format|
      if game.move(current_session, params[:cell_index].to_i)
        format.html { redirect_to game_path(game) }
        format.turbo_stream
      else
        format.html { redirect_to game_path(game), flash: { warning: game.errors.full_messages.first } }
        format.turbo_stream do
          flash.now[:warning] = game.errors.full_messages.first
          render_flash
        end
      end
    end
  end

  private

  def game_over_message
    return unless @game && @game.player_1 && @game.player_2

    winner = @game.winner

    name =
      if winner == @game.player_1
        "Player 1"
      elsif winner == @game.player_2
        "Player 2"
      else
        nil
      end

    "Game Over: #{name} wins" if winner
  end
  helper_method :game_over_message
end
