module Arbre
  class Component < Arbre::HTML::Div

    # By default components render a div
    def tag_name
      'div'
    end

    def initialize(*)
      super
      add_class default_class_name
    end

    protected

    # By default, add a css class named after the ruby class
    def default_class_name
      self.class.name.demodulize.underscore
    end

  end
end
