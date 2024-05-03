class Router
  @routes = {}

  class << self
    attr_reader :routes

    def define(&block)
      tap do
        instance_eval(&block)
      end
    end

    def definitions
      routes = @routes.dup

      {}.tap do |defs|
        defs["index.html"] = routes.delete("/")
        routes.each do |path, to|
          defs["#{path}.html"] = to
        end
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
