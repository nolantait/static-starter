# frozen_string_literal: true

class Router
  # DOCS: Holds routes as a class instance variable. This class is expected to
  # be used as a singleton by requiring the "routes.rb" file.
  #
  # NOTE: Why do we need our own router? Why not just use Roda for these
  # definitions? Roda is a routing tree and cannot be introspected easily.

  @routes = {}

  class << self
    attr_reader :routes

    def define(&block)
      @routes = {}

      tap do
        instance_eval(&block)
      end
    end

    def filepaths
      routes.dup
        .then do |routes|
          routes["index"] = routes.delete("/")
          routes.transform_keys { |key| "#{key}.html" }
        end
    end

    def match(path, to:)
      @routes[path] = to
    end

    def root(to:)
      @routes["/"] = to
    end

    def resolve(path)
      case value = @routes[path]
      when Class then value.new
      else
        value
      end
    end
  end
end
