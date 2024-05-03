class Post < Protos::Markdown
  include Protos::Typography
  option :front_matter, default: -> { {} }

  def around_template
    render Layouts::Post.new do
      header(class: "text-center py-md flex flex-col gap-2") do
        h1 { front_matter[:title] }
        span(class: "text-sm") do
          plain "Last updated: "
          time(datetime: front_matter[:date].iso8601) do
            front_matter[:date].strftime("%B %d, %Y")
          end
        end
      end

      div(class: "prose max-w-none") do
        super
      end

      footer do
        if front_matter[:sources] && front_matter[:sources].any?
          h2 { "Read more" }
          ul(class: "overflow-x-auto") do
            front_matter[:sources].each do |href|
              li do
                a(href:, class: "link") { href }
              end
            end
          end
        end
      end
    end
  end
end
