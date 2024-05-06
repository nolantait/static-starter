# Static starter

This is a minimal static site builder with [phlex](https://phlex.fun) and
[protos](https://github.com/inhouse-work/protos) component library.

Everything is ruby, there is no html or erb. It outputs a static site to the
`build/` folder.

## Usage

```
git clone https://github.com/nolantait/static-starter
cd static-starter
bin/setup
bin/dev
```

## Building

When your site it built with `bin/build` it will output everything defined in
your `config/routes` as well as anything in `public/`. You can then serve these
using something like nginx.

You can deploy this as-is to an instance of `dokku` which will build the site
and serve it according to the `app-nginx.conf.sigil`

## Views

Views are defined in `app/pages` and `app/layouts`. `app/components` are for
your general components that many pages or layouts might use.

## Javascript

All javascript and images are handled via [Vite](https://vite-ruby.netlify.app/)

## Router

Your routes are defined in `config/routes.rb` and determine the output for your
site. Everything gets built into the `build/` folder by default.

Here is an example of loading content for a blog:

```ruby
# frozen_string_literal: true

require "date"
require "front_matter_parser"

loader = FrontMatterParser::Loader::Yaml.new(allowlist_classes: [Date])

Router.define do
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
```
