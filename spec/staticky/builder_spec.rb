# frozen_string_literal: true

RSpec.describe Staticky::Builder do
  it "compiles the homepage" do
    files = Staticky::Files.test
    files.touch(
      "public/favicon.ico",
      "public/robots.txt",
      "public/sitemap.xml",
      "public/android-chrome-192x192.png",
      "public/android-chrome-512x512.png",
      "public/apple-touch-icon.png",
      "public/favicon-16x16.png",
      "public/favicon-32x32.png",
      "public/site.webmanifest"
    )

    builder = described_class.new(
      files:,
      root: Pathname.new("."),
      output: "build"
    )
    builder.call

    expect(files.exist?("build/index.html")).to be(true)
    expect(files.exist?("build/404.html")).to be(true)
    expect(files.exist?("build/500.html")).to be(true)
    expect(files.exist?("build/favicon.ico")).to be(true)
  end
end
