# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # This cop looks for uses of the *for* keyword, or *each* method. The
      # preferred alternative is set in the EnforcedStyle configuration
      # parameter. An *each* call with a block on a single line is always
      # allowed, however.
      class For < Cop
        include ConfigurableEnforcedStyle
        EACH_LENGTH = 'each'.length

        def on_for(node)
          if style == :each
            add_offense(node, :keyword, 'Prefer `each` over `for`.') do
              opposite_style_detected
            end
          else
            correct_style_detected
          end
        end

        def on_block(node)
          return if node.single_line?

          return unless node.send_node.method?(:each) &&
                        !node.send_node.arguments?

          if style == :for
            incorrect_style_detected(node.send_node)
          else
            correct_style_detected
          end
        end

        private

        def incorrect_style_detected(method)
          end_pos = method.source_range.end_pos
          range = range_between(end_pos - EACH_LENGTH, end_pos)
          add_offense(range, range, 'Prefer `for` over `each`.') do
            opposite_style_detected
          end
        end
      end
    end
  end
end
