# frozen_string_literal: true

module Pages
  class NotFound < Page
    def view_template
      h1 { "Page not found." }
    end
  end
end
