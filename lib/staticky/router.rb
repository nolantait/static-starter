# frozen_string_literal: true

module Staticky
  class Router
    # DOCS: Holds routes as a class instance variable. This class is expected to
    # be used as a singleton by requiring the "routes.rb" file.
    #
    # NOTE: Why do we need our own router? Why not just use Roda for these
    # definitions? Roda is a routing tree and cannot be introspected easily.

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

    @definition = Definition.new

    class << self
      attr_reader :routes

      def define(&block)
        tap do
          @definition.instance_eval(&block)
        end
      end

      def filepaths
        @definition.filepaths
      end

      def endpoints
        @definition.endpoints
      end

      def resolve(path)
        case value = @definition.resolve(path)
        when Class then value.new
        else
          value
        end
      end
    end
  end
end
