# frozen_string_literal: true

module Staticky
  # DOCS: Module for static site infrastructure such as:
  # - Defining routes
  # - Compiling templates
  # - Development server
  # - Managing filesystem

  ROOT_PATH = Pathname.new(__dir__).join("..").expand_path

  Environment = Data.define(:name) do
    def development?
      name == "development"
    end
  end

  def self.build_path
    ROOT_PATH.join("build")
  end

  def self.resources
    Staticky::Router.resources
  end

  def self.env
    Environment.new(ENV.fetch("RACK_ENV", nil))
  end

  module ViewHelpers
    def link_to(text, href, **, &block) # rubocop:disable Metrics/ParameterLists
      block = proc { text } unless block_given?

      a(href: Router.resolve(href).url, **, &block)
    end
  end

  Phlex::SGML.prepend Staticky::ViewHelpers
end
