# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby_version = Pathname.new(__dir__).join(".ruby-version")
ruby ruby_version.read.strip

gem "protos"
gem "protos-icon"
gem "protos-markdown", github: "inhouse-work/protos-markdown", branch: "master"

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
