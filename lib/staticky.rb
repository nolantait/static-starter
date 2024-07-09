# frozen_string_literal: true

module Staticky
  # DOCS: Module for static site infrastructure such as:
  # - Defining routes
  # - Compiling templates
  # - Development server
  # - Managing filesystem

  ROOT_PATH = Pathname.new(__dir__).join("..").expand_path
end
