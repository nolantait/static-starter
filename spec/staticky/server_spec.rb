require "capybara"
require "capybara/rspec"

Capybara.app = Staticky::Server

RSpec.describe Staticky::Server, type: :feature do
  it "boots up the app" do
    visit "/"

    expect(page).to have_content("MyApp")
  end
end
