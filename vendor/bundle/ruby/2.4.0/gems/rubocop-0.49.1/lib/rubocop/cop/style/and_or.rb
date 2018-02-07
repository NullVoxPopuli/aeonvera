# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # This cop checks for uses of *and* and *or*.
      class AndOr < Cop
        include ConfigurableEnforcedStyle

        MSG = 'Use `%s` instead of `%s`.'.freeze

        OPS = { 'and' => '&&', 'or' => '||' }.freeze

        def on_and(node)
          process_logical_op(node) if style == :always
        end

        def on_or(node)
          process_logical_op(node) if style == :always
        end

        def on_if(node)
          on_conditionals(node) if style == :conditionals
        end

        def on_while(node)
          on_conditionals(node) if style == :conditionals
        end

        def on_while_post(node)
          on_conditionals(node) if style == :conditionals
        end

        def on_until(node)
          on_conditionals(node) if style == :conditionals
        end

        def on_until_post(node)
          on_conditionals(node) if style == :conditionals
        end

        private

        def on_conditionals(node)
          node.condition.each_node(*LOGICAL_OPERATOR_NODES) do |logical_node|
            process_logical_op(logical_node)
          end
        end

        def process_logical_op(node)
          return if node.logical_operator?

          add_offense(node, :operator,
                      format(MSG, node.alternate_operator, node.operator))
        end

        def autocorrect(node)
          lambda do |corrector|
            [*node].each do |expr|
              if expr.send_type?
                correct_send(expr, corrector)
              elsif expr.return_type?
                correct_other(expr, corrector)
              elsif expr.assignment?
                correct_other(expr, corrector)
              end
            end

            corrector.replace(node.loc.operator, node.alternate_operator)
          end
        end

        def correct_send(node, corrector)
          return correct_not(node, node.receiver, corrector) if node.method?(:!)
          return correct_setter(node, corrector) if node.setter_method?
          return unless correctable_send?(node)

          corrector.replace(whitespace_before_arg(node), '('.freeze)
          corrector.insert_after(node.last_argument.source_range, ')'.freeze)
        end

        def correct_setter(node, corrector)
          corrector.insert_before(node.receiver.source_range, '('.freeze)
          corrector.insert_after(node.last_argument.source_range, ')'.freeze)
        end

        # ! is a special case:
        # 'x and !obj.method arg' can be auto-corrected if we
        # recurse down a level and add parens to 'obj.method arg'
        # however, 'not x' also parses as (send x :!)
        def correct_not(node, receiver, corrector)
          if node.keyword_bang?
            return unless receiver.send_type?

            correct_send(receiver, corrector)
          elsif node.keyword_not?
            correct_other(node, corrector)
          else
            raise 'unrecognized unary negation operator'
          end
        end

        def correct_other(node, corrector)
          return if node.source_range.begin.is?('(')

          corrector.insert_before(node.source_range, '(')
          corrector.insert_after(node.source_range, ')')
        end

        def correctable_send?(node)
          !node.parenthesized? && !node.method?(:[]) && node.arguments?
        end

        def whitespace_before_arg(node)
          begin_paren = node.loc.selector.end_pos
          end_paren = begin_paren
          # Increment position of parenthesis, unless message is a predicate
          # method followed by a non-whitespace char (e.g. is_a?String).
          end_paren += 1 unless node.source =~ /\?\S/
          range_between(begin_paren, end_paren)
        end
      end
    end
  end
end
