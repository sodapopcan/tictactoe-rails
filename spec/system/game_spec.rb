require 'rails_helper'

RSpec.describe "Game", type: :system do
  before do
    driven_by(:rack_test)
  end

  scenario "a user visits the homepage" do
    visit root_path

    expect(page).to have_content(/Create a game/)
  end

  feature "starting a game" do
    scenario "a user starts a game" do
      create_a_game

      expect(page).to have_content(/Player 1: \d+/)
    end

    scenario "a user is redirected gack to the game they are playing" do
      create_a_game

      visit root_path

      game = Game.first
      expect(current_path).to eq(game_path(game))
    end

    scenario "another user may join a game" do
      game = create(:game)

      visit root_path
      click_on "Join game #{game.id}"

      game.reload

      expect(current_path).to eq(game_path(game))
      expect(page).to have_content(/Player 1: #{game.player_1.id}/)
      expect(page).to have_content(/Player 2: #{game.player_2.id}/)
    end

    scenario "a third user tries to join" do
      game = create(:game)

      visit root_path

      game.join(create(:session))

      click_on "Join game #{game.id}"

      expect(page).to have_content(/Cannot join game/)
    end
  end

  def create_a_game
    visit root_path
    click_on "Create a game"
  end
end
