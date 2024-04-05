# frozen_string_literal: true

module Pages
  class Home < Page
    def template
      render Layouts::Site.new do
        h1 { "Hello world" }
      end
    end
  end
end
