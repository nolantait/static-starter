# frozen_string_literal: true

ENV["RACK_ENV"] ||= "development"

require_relative "site"
require "bundler"
Bundler.require(:default, :development)

loader = Zeitwerk::Loader.new
loader.push_dir("lib")
loader.push_dir("app")
loader.setup
