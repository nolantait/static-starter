# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

gem "protos", github: "inhouse-work/protos", branch: "master"
gem "protos-icon"
gem "protos-markdown", path: "../protos-markdown" # github: "inhouse-work/protos-markdown", branch: "master"

gem "dry-files"
gem "dry-inflector"
gem "front_matter_parser"
gem "phlex"
gem "rack"
gem "rackup"
gem "rake"
gem "rouge"
gem "tilt"
gem "vite_ruby"
gem "zeitwerk"

group :test do
  gem "debug"
  gem "phlex-testing-capybara"
  gem "rspec"
end

group :development do
  gem "listen"
  gem "rerun"
  gem "roda"
  gem "rubocop-inhouse", require: false
end
