# frozen_string_literal: true

require "logger"

require "./config/boot"

Staticky.configure do |config|
  config.logger = Logger.new($stdout)
end

require "staticky/server"

use(ViteRuby::DevServerProxy, ssl_verify_none: true) if ViteRuby.run_proxy?
run Staticky::Server.app.freeze
