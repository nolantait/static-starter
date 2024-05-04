class Post < Protos::Markdown
  include Protos::Typography
  option :front_matter, default: -> { {} }

  def around_template
    render Layouts::Post.new do
      header(class: "text-center py-md flex flex-col gap-2") do
        h1 { front_matter[:title] }
        span(class: "text-sm") do
          plain "Last updated: "
          time(datetime: date.iso8601) { date.strftime("%B %d, %Y") }
        end
      end

      div(class: "prose mx-auto pb-lg") do
        super

        footer do
          if sources.any?
            h2 { "Read more" }
            ul(class: "overflow-x-auto") do
              sources.each do |href|
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

  private

  def date
    front_matter[:date] || Date.today
  end

  def sources
    front_matter[:sources] || []
  end
end
