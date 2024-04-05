# frozen_string_literal: true

module Pages
  class ServiceError < Page
    def template
      h1 { "Something went wrong." }
    end
  end
end
