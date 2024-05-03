# frozen_string_literal: true

require "./config/boot"
require "logger"
require "./lib/routes"

class Server < Roda
  # plugin :public, root: "build"
  plugin :common_logger, Logger.new($stdout), method: :info
  plugin :render, engine: "html"

  plugin :error_handler do |_e|
    File.read("build/500.html")
  end

  plugin :not_found do
    File.read("build/404.html")
  end

  route do |r|
    Router.filepaths.each_key do |filepath|
      path = filepath.gsub(".html", "")

      if path == "index"
        r.root do
          render(inline: File.read("build/index.html"))
        end
      else
        r.get path do
          render(inline: File.read("build/#{filepath}"))
        end
      end
    end
  end
end

use(ViteRuby::DevServerProxy, ssl_verify_none: true) if ViteRuby.run_proxy?
run Server.freeze.app
