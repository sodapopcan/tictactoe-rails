require 'rails_helper'

RSpec.describe "Home", type: :system do
  before do
    driven_by(:rack_test)
  end

  scenario "a user visits the homepage" do
    visit root_path

    expect(page).to have_content(/Create a game/)
  end
end
