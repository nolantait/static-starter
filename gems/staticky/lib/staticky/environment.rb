module Staticky
  Environment = Data.define(:name) do
    def development? = name == :development
    def test? = name == :test
  end
end
