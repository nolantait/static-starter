# frozen_string_literal: true

require "date"
require "front_matter_parser"

loader = FrontMatterParser::Loader::Yaml.new(allowlist_classes: [Date])

Staticky.router.define do
  root to: Pages::Home
  match "404", to: Pages::NotFound
  match "500", to: Pages::ServiceError
  match "test", to: Pages::Nested::Test

  Dir["content/**/*.md"].each do |file|
    parsed = FrontMatterParser::Parser.parse_file(file, loader:)

    match file.gsub("content/", "").gsub(".md", ""),
          to: Pages::Post.new(
            parsed.content,
            front_matter: parsed.front_matter.transform_keys(&:to_sym)
          )
  end
end
