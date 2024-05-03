# frozen_string_literal: true

module Pages
  class ServiceError < Page
    def view_template
      h1 { "Something went wrong." }
    end
  end
end
