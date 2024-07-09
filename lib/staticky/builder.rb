# frozen_string_literal: true

module Staticky
  class Builder
    class << self
      def call(...)
        new(...).call
      end
    end

    def initialize(files: Dry::Files.new, output: "build", router: Router)
      @files = files
      @output_path = Pathname.new(output)
      @router = router
    end

    def call
      copy_public_files
      build_site
    end

    private

    def build_site
      @router
        .filepaths
        .each do |filepath, component|
          compile(filepath, render(component))
        end
    end

    def render(component)
      component.call(view_context: nil)
    end

    def copy_public_files
      Dir["public/*"].each do |file|
        copy(file, file.gsub("public/", ""))
      end
    end

    def compile(filepath, content)
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
end
