# frozen_string_literal: true

module Pages
  module Nested
    class Test < Page
      def view_template
        h1 { "Im a nested page" }
      end
    end
  end
end
