# frozen_string_literal: true

module Pages
  class NotFound < Page
    def template
      h1 { "Page not found." }
    end
  end
end
