# frozen_string_literal: true

module Pages
  class Home < Page
    def template
      render Layouts::Site.new(
        class: css[:layout]
      ) do
        page_title { "Hello world" }
      end
    end

    private

    def page_title(&block)
      render Protos::Typography::Heading.new(
        size: :xl,
        class: "px-sm py-md",
        &block
      )
    end
  end
end
