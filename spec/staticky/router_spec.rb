# frozen_string_literal: true

RSpec.describe Staticky::Router do
  it "defines routes" do
    router = described_class.define do
      root to: Pages::Home
      match "hello", to: Pages::Home
    end

    expect(router.resolve("/")).to be_a(Pages::Home)
    expect(router.resolve("hello")).to be_a(Pages::Home)
    expect(router.filepaths.keys).to include("index.html", "hello.html")
  end
end
