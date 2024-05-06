# frozen_string_literal: true

class Component < Protos::Component
  include ViteHelpers

  def icon(...)
    render Icon.new(...)
  end
end
