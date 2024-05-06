# frozen_string_literal: true

module Layouts
  class Post < Layout
    def view_template(...)
      render Layouts::Site.new(...)
    end
  end
end
