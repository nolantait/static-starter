# frozen_string_literal: true

class Page < Component
  # This lets us set the layout for the page with something like:
  #
  # ````
  # def self.layout = SomeLayout
  # ````
  #
  # Placing that at the top of the page will set the layout for the page with
  # the default initialization defined below in the #around_template
  def self.layout
    @layout ||= Layouts::Site
  end

  # `around_template` is a method that wraps the view_template in the layout
  # this comes from Phlex. It gets passed a block that is the view_template
  def around_template
    render self.class.layout.new do
      super
    end
  end
end
