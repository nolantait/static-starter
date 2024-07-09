# frozen_string_literal: true

module Staticky
  class Server < Roda
    plugin :common_logger, Logger.new($stdout), method: :info
    plugin :render, engine: "html"

    @root = Staticky::ROOT_PATH.join("build/development")

    plugin :error_handler do |_e|
      @root.join("500.html").read
    end

    plugin :not_found do
      @root.join("404.html").read
    end

    route do |r|
      Router.filepaths.each_key do |filepath|
        case filepath
        when "index.html"
          r.root do
            render(inline: @root.join("index.html").read)
          end
        else
          r.get path do
            render(inline: @root.join("#{filepath}.html").read)
          end
        end
      end
    end
  end
end
