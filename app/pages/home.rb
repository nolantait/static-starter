# frozen_string_literal: true

module Pages
  class Home < Page
    include Protos::Typography

    def view_template
      render Protos::Hero.new(
        class: "h-96",
        style: "background-image: url(https://images.unsplash.com/photo-1642508334860-dd4584ac3eed?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D)"
      ) do |hero|
        hero.overlay(class: "opacity-90")
        hero.content(class: "flex-col text-white") do
          h1 { "Ruby maximalism" }
          p(margin: false) { "Zen vibes only" }
        end
      end
    end
  end
end
