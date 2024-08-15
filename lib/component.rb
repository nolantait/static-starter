# frozen_string_literal: true

require "staticky/phlex/view_helpers"

class Component < Protos::Component
  include ViteHelpers

  def asset_path(...)
    vite_asset_path(...)
  end

  def icon(...)
    render Icon.new(...)
  end
end
