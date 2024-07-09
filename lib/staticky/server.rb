# frozen_string_literal: true

require_relative "../staticky"

module Staticky
  class Server < Roda
    plugin :common_logger, Logger.new($stdout), method: :info
    plugin :render, engine: "html"

    plugin :error_handler do |e|
      Staticky.build_path.join("500.html").read
    end

    plugin :not_found do
      Staticky.build_path.join("404.html").read
    end

    route do |r|
      Router.filepaths.each do |filepath|
        case filepath
        when "index.html"
          r.root do
            render(inline: Staticky.build_path.join("index.html").read)
          end
        else
          r.get path do
            render(inline: Staticky.build_path.join("#{filepath}.html").read)
          end
        end
      end
    end
  end
end
