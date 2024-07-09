# frozen_string_literal: true

require_relative "../staticky"

module Staticky
  class Server < Roda
    plugin :common_logger, Logger.new($stdout), method: :debug
    plugin :render, engine: "html"

    plugin :not_found do
      Staticky.build_path.join("404.html").read
    end

    plugin :error_handler do |e|
      raise e
      Staticky.build_path.join("500.html").read
    end

    route do |r|
      Router.resources.each do |resource|
        case resource.filepath
        when "index.html"
          r.root do
            render(inline: Staticky.build_path.join(resource.filepath).read)
          end
        else
          r.get resource.url do
            render(inline: Staticky.build_path.join(resource.filepath).read)
          end
        end
      end

      nil
    end
  end
end
