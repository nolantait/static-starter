# frozen_string_literal: true

module Pages
  class Home < Page
    def template
      h1 { "Hello world" }
    end
  end
end
