# frozen_string_literal: true

ENV["RACK_ENV"] ||= "development"

require "bundler"
Bundler.require(:default, :development)

loader = Zeitwerk::Loader.new
loader.push_dir("lib")
loader.push_dir("app")
loader.setup

require "./config/routes"
require_relative "site"
