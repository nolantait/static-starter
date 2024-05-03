# frozen_string_literal: true

class Builder
  class << self
    attr_accessor :loader

    def call(...)
      new(...).call
    end
  end

  def initialize(files: Dry::Files.new, output: "build")
    @files = files
    @output_path = Pathname.new(output)
  end

  def call
    compile("index.html") { Pages::Home.new.call }
    compile("404.html") { Pages::NotFound.new.call }
    compile("500.html") { Pages::ServiceError.new.call }
    copy("public/robots.txt", "robots.txt")
    copy("public/sitemap.xml", "sitemap.xml")
    copy(
      "public/android-chrome-192x192.png",
      "android-chrome-192x192.png"
    )
    copy(
      "public/android-chrome-512x512.png",
      "android-chrome-512x512.png"
    )
    copy("public/apple-touch-icon.png", "apple-touch-icon.png")
    copy("public/favicon-16x16.png", "favicon-16x16.png")
    copy("public/favicon-32x32.png", "favicon-32x32.png")
    copy("public/favicon.ico", "favicon.ico")
    copy("public/site.webmanifest", "site.webmanifest")
  end

  def watch
    listener.start
    sleep
  end

  private

  def listener
    call

    Listen.to("app") do
      puts "Rebuilding..."
      self.class.loader.reload
      call
    end
  end

  def compile(filepath)
    content = yield
    @files.write(
      @output_path.join(filepath),
      content
    )
  end

  def copy(source, destination)
    @files.cp(
      source,
      @output_path.join(destination)
    )
  end
end
