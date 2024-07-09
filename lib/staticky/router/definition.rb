module Staticky
  class Router
    class Definition
      def initialize
        @routes = {}
      end

      def match(path, to:)
        @routes[path] = to
      end

      def root(to:)
        @routes["/"] = to
      end

      def resolve(path)
        @routes.fetch(path)
      end

      def delete(path)
        @routes.delete(path)
      end

      def endpoints
        @routes.transform_keys do |key|
          rename_key(key)
        end
      end

      def filepaths
        @routes.keys.map do |key|
          rename_key(key)
        end
      end

      private

      def rename_key(key)
        return "index.html" if key == "/"

        "#{key}.html"
      end
    end
  end
end
