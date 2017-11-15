# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # This cop enforces the use of consistent method names
      # from the String class.
      class StringMethods < Cop
        include MethodPreference

        MSG = 'Prefer `%s` over `%s`.'.freeze

        def on_send(node)
          return unless preferred_method(node.method_name)

          add_offense(node, :selector)
        end

        private

        def message(node)
          format(MSG, preferred_method(node.method_name), node.method_name)
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(node.loc.selector,
                              preferred_method(node.method_name))
          end
        end
      end
    end
  end
end
