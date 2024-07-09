module Staticky
  class Files < SimpleDelegator
    def self.test
      files = Dry::Files.new(memory: true)
      new(files)
    end

    def self.real
      files = Dry::Files.new
      new(files)
    end

    def touch(*files)
      files.each do |file|
        super(file)
      end
    end
  end
end
