# frozen_string_literal: true

module RuboCop
  module Cop
    module Rails
      # This cop checks for the use of output calls like puts and print
      class Output < Cop
        MSG = 'Do not write to stdout. ' \
              "Use Rails's logger if you want to log.".freeze

        def_node_matcher :output?, <<-PATTERN
          (send nil {:ap :p :pp :pretty_print :print :puts} ...)
        PATTERN

        def on_send(node)
          return unless output?(node) && node.arguments?

          add_offense(node, :selector)
        end
      end
    end
  end
end
