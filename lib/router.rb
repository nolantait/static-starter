class Router
  @routes = {}

  class << self
    attr_reader :routes

    def define(&block)
      tap do
        instance_eval(&block)
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
