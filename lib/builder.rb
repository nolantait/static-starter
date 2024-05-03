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
    copy_public_files
  end

  def watch
    listener.start
    sleep
  end

  private

  def copy_public_files
    Dir["public/*"].each do |file|
      copy(file, file.gsub("public/", ""))
    end
  end

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
