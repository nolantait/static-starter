# frozen_string_literal: true

module Staticky
  class Builder
    def self.call(...) = new(...).call

    def initialize(
      files: Staticky::Files.real,
      output: "build",
      root: Staticky::ROOT_PATH,
      router: Staticky::Router
    )
      @files = files
      @root_path = root
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
        .endpoints
        .each do |filepath, component|
          compile(filepath, render(component))
        end
    end

    def render(component)
      component.call(view_context: nil)
    end

    def copy_public_files
      @files.children(@root_path.join("public")).each do |file|
        copy(public_path(file), file.gsub("public/", ""))
      end
    end

    def compile(filepath, content)
      @files.write output_path(filepath), content
    end

    def copy(source, destination)
      @files.cp source, output_path(destination)
    end

    def public_path(path)
      @root_path.join("public", path)
    end

    def output_path(path)
      @output_path.join(path)
    end
  end
end
