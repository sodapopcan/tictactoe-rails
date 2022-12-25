require 'rails_helper'

RSpec.describe "Game", type: :system do
  before do
    driven_by(:rack_test)
  end

  scenario "a user visits the homepage" do
    visit root_path

    expect(page).to have_content(/Create a game/)
  end

  scenario "a user starts a game" do
    visit root_path

    click_on "Create a game"

    expect(page).to have_content(/Player 1: \d+/)
  end

  scenario "a user is redirected gack to the game they are playing" do
    visit root_path

    click_on "Create a game"

    visit root_path

    game = Game.first
    expect(current_path).to eq(game_path(game))
  end
end
