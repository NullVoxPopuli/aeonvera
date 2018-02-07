# frozen_string_literal: true

module RuboCop
  module Cop
    # Common functionality for checking the closing brace of a literal is
    # either on the same line as the last contained elements, or a new line.
    module MultilineLiteralBraceLayout
      include ConfigurableEnforcedStyle

      def check_brace_layout(node)
        return if ignored_literal?(node)

        # If the last node is or contains a conflicting HEREDOC, we don't want
        # to adjust the brace layout because this will result in invalid code.
        return if last_line_heredoc?(node.children.last)

        check(node)
      end

      def autocorrect(node)
        if closing_brace_on_same_line?(node)
          lambda do |corrector|
            corrector.insert_before(node.loc.end, "\n".freeze)
          end
        else
          lambda do |corrector|
            corrector.remove(range_with_surrounding_space(node.loc.end,
                                                          :left))

            corrector.insert_after(last_element_range_with_trailing_comma(node),
                                   node.loc.end.source)
          end
        end
      end

      private

      def check(node)
        case style
        when :symmetrical then check_symmetrical(node)
        when :new_line then check_new_line(node)
        when :same_line then check_same_line(node)
        end
      end

      def check_new_line(node)
        return unless closing_brace_on_same_line?(node)

        add_offense(node, :end, self.class::ALWAYS_NEW_LINE_MESSAGE)
      end

      def check_same_line(node)
        return if closing_brace_on_same_line?(node)

        add_offense(node, :end, self.class::ALWAYS_SAME_LINE_MESSAGE)
      end

      def check_symmetrical(node)
        if opening_brace_on_same_line?(node)
          return if closing_brace_on_same_line?(node)

          add_offense(node, :end, self.class::SAME_LINE_MESSAGE)
        else
          return unless closing_brace_on_same_line?(node)

          add_offense(node, :end, self.class::NEW_LINE_MESSAGE)
        end
      end

      def ignored_literal?(node)
        implicit_literal?(node) || empty_literal?(node) || node.single_line?
      end

      def implicit_literal?(node)
        !node.loc.begin
      end

      def empty_literal?(node)
        children(node).empty?
      end

      def last_element_range_with_trailing_comma(node)
        trailing_comma_range = last_element_trailing_comma_range(node)
        if trailing_comma_range
          children(node).last.source_range.join(trailing_comma_range)
        else
          children(node).last.source_range
        end
      end

      def last_element_trailing_comma_range(node)
        range = range_with_surrounding_space(children(node).last.source_range,
                                             :right).end.resize(1)
        range.source == ',' ? range : nil
      end

      def children(node)
        node.children
      end

      # This method depends on the fact that we have guarded
      # against implicit and empty literals.
      def opening_brace_on_same_line?(node)
        node.loc.begin.line == children(node).first.loc.first_line
      end

      # This method depends on the fact that we have guarded
      # against implicit and empty literals.
      def closing_brace_on_same_line?(node)
        node.loc.end.line == children(node).last.loc.last_line
      end

      # Starting with the parent node and recursively for the parent node's
      # children, check if the node is a HEREDOC and if the HEREDOC ends below
      # or on the last line of the parent node.
      #
      # Example:
      #
      #   # node is `b: ...` parameter
      #   # last_line_heredoc?(node) => false
      #   foo(a,
      #     b: {
      #       a: 1,
      #       c: <<-EOM
      #         baz
      #       EOM
      #     }
      #   )
      #
      #   # node is `b: ...` parameter
      #   # last_line_heredoc?(node) => true
      #   foo(a,
      #     b: <<-EOM
      #       baz
      #     EOM
      #   )
      def last_line_heredoc?(node, parent = nil)
        parent ||= node

        if node.respond_to?(:loc) &&
           node.loc.respond_to?(:heredoc_end) &&
           node.loc.heredoc_end.last_line >= parent.loc.last_line
          return true
        end

        return false unless node.respond_to?(:children)

        node.children.any? { |child| last_line_heredoc?(child, parent) }
      end
    end
  end
end
