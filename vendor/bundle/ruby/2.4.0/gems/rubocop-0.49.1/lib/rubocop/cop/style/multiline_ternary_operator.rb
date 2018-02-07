# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # This cop checks for multi-line ternary op expressions.
      class MultilineTernaryOperator < Cop
        MSG = 'Avoid multi-line ternary operators, ' \
              'use `if` or `unless` instead.'.freeze

        def on_if(node)
          return unless node.ternary? && node.multiline?

          add_offense(node, :expression)
        end
      end
    end
  end
end
