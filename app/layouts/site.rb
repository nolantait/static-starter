# frozen_string_literal: true

module Layouts
  class Site < Layout
    def view_template(&block)
      html lang: "en_US", data: { theme: "onedark" } do
        head do
          title { ::Site.title }
          meta property: "og:title", content: ::Site.title
          meta property: "og:type", content: "website"
          meta property: "og:locale", content: "en_US"
          meta name: "description", content: ::Site.description
          link rel: "canonical", href: ::Site.url
          meta property: "og:url", content: ::Site.url
          meta property: "og:site_name", content: ::Site.title
          meta name: "twitter:card", content: "summary"
          meta property: "twitter:title", content: ::Site.title
          meta name: "twitter:site", content: ::Site.twitter
          meta name: "twitter:creator", content: ::Site.twitter

          meta name: "viewport",
               content: "width=device-width,initial-scale=1,viewport-fit=cover"
          meta name: "turbo-cache-control", content: "no-preview"
          meta name: "theme-color", content: "#61afef"
          meta name: "mobile-web-app-capable", content: "yes"
          meta name: "apple-touch-fullscreen", content: "yes"
          meta name: "apple-mobile-web-app-capable", content: "yes"
          meta name: "apple-mobile-web-app-status-bar-style", content: "default"
          meta name: "apple-mobile-web-app-title", content: ::Site.title
          vite_client_tag unless ENV["RACK_ENV"] == "production"
          vite_javascript_tag "application"
        end

        body do
          render Components::Navbar.new
          main(**attrs, &block)
        end
      end
    end

    private

    def theme
      {
        container: tokens(
          "min-h-screen",
          "bg-base-300"
        )
      }
    end
  end
end
