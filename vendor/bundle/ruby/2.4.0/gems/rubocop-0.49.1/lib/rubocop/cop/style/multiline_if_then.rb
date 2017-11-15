# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # Checks for uses of the `then` keyword in multi-line if statements.
      #
      # @example This is considered bad practice:
      #
      #   if cond then
      #   end
      #
      # @example If statements can contain `then` on the same line:
      #
      #   if cond then a
      #   elsif cond then b
      #   end
      class MultilineIfThen < Cop
        include OnNormalIfUnless

        NON_MODIFIER_THEN = /then\s*(#.*)?$/

        MSG = 'Do not use `then` for multi-line `%s`.'.freeze

        def on_normal_if_unless(node)
          return unless non_modifier_then?(node)

          add_offense(node, :begin, format(MSG, node.keyword))
        end

        private

        def non_modifier_then?(node)
          node.loc.begin && node.loc.begin.source_line =~ NON_MODIFIER_THEN
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.remove(
              range_with_surrounding_space(node.loc.begin, :left)
            )
          end
        end
      end
    end
  end
end
