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
      session_1 = Capybara::Session.new(:rack_test, Rails.application)
      session_2 = Capybara::Session.new(:rack_test, Rails.application)
      session_3 = Capybara::Session.new(:rack_test, Rails.application)

      session_1.visit root_path
      session_1.click_on "Create a game"

      session_2.visit root_path
      session_3.visit root_path

      session_2.click_on "Join game"
      session_3.click_on "Join game"

      expect(session_3).to have_content(/Cannot join game/)
    end
  end

  feature "playing a game" do
    scenario "player 1 makes a move" do
      create_a_game

      game = Game.first
      game.join(create(:session))

      visit game_path(game)
      find("[data-cell-index=0] input[type=submit]").click

      within "[data-cell-index=0]" do
        expect(page).not_to have_selector("form")
        expect(page).to have_selector("[data-player=x]")
      end
    end
  end

  def create_a_game
    visit root_path
    click_on "Create a game"
  end
end
