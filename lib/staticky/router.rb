# frozen_string_literal: true

module Staticky
  class Router
    # DOCS: Holds routes as a class instance variable. This class is expected to
    # be used as a singleton by requiring the "routes.rb" file.
    #
    # NOTE: Why do we need our own router? Why not just use Roda for these
    # definitions? Roda is a routing tree and cannot be introspected easily.

    @definition = Staticky::Router::Definition.new

    class << self
      def define(&block)
        tap do
          @definition.instance_eval(&block)
        end
      end

      def filepaths
        @definition.filepaths
      end

      def resources
        @definition.resources
      end

      def resolve(path)
        @definition.resolve(path)
      end
    end
  end
end
