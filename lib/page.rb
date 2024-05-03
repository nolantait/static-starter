# frozen_string_literal: true

class Page < Component
  def self.layout
    @layout ||= Layouts::Site
  end

  def around_template
    render self.class.layout.new do
      super
    end
  end
end
