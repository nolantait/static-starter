require_relative "../staticky"

module Staticky
  Resource = Data.define(:url, :component) do
    def filepath
      root? ? "index.html" : "#{url}.html"
    end

    def root?
      url == "/"
    end
  end
end
