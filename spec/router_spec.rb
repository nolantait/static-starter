RSpec.describe Router do
  it "defines routes" do
    router = Router.define do
      root to: Pages::Home
      match "hello", to: Pages::Home
    end

    expect(router.resolve("/")).to be_a(Pages::Home)
    expect(router.resolve("hello")).to be_a(Pages::Home)

    expect(router.definitions.keys).to include("index.html")
    expect(router.definitions.keys).to include("hello.html")
  end
end
