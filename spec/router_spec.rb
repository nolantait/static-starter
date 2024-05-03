RSpec.describe Router do
  it "defines routes" do
    router = Router.define do
      root to: Pages::Home
      match "hello", to: Pages::Home
    end

    expect(router.resolve("/")).to be_a(Pages::Home)
    expect(router.resolve("hello")).to be_a(Pages::Home)
  end
end
