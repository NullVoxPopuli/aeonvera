# frozen_string_literal: true

module RuboCop
  module Cop
    module Rails
      # This cops checks for code that can be changed to `blank?`.
      # Settings:
      #   NilOrEmpty: Convert checks for `nil` or `empty?` to `blank?`
      #   NotPresent: Convert usages of not `present?` to `blank?`
      #   UnlessPresent: Convert usages of `unless` `present?` to `blank?`
      #
      # @example
      #   # NilOrEmpty: true
      #     # bad
      #     foo.nil? || foo.empty?
      #     foo == nil || foo.empty?
      #
      #     # good
      #     foo.blank?
      #
      #   # NotPresent: true
      #     # bad
      #     !foo.present?
      #
      #     # good
      #     foo.blank?
      #
      #   # UnlessPresent: true
      #     # bad
      #     something unless foo.present?
      #     unless foo.present?
      #       something
      #     end
      #
      #     # good
      #     something if foo.blank?
      #     if foo.blank?
      #       something
      #     end
      class Blank < Cop
        MSG_NIL_OR_EMPTY = 'Use `%s.blank?` instead of `%s`.'.freeze
        MSG_NOT_PRESENT = 'Use `%s` instead of `%s`.'.freeze
        MSG_UNLESS_PRESENT = 'Use `if %s.blank?` instead of `%s`.'.freeze

        def_node_matcher :nil_or_empty?, <<-PATTERN
          (or
              {
                (send $_ :!)
                (send $_ :nil?)
                (send $_ :== (:nil))
                (send (:nil) :== $_)
              }
              {
                (send $_ :empty?)
                (send (send (send $_ :empty?) :!) :!)
              }
          )
        PATTERN

        def_node_matcher :not_present?, '(send (send $_ :present?) :!)'

        def_node_matcher :unless_present?, <<-PATTERN
          (:if $(send $_ :present?) {nil (...)} ...)
        PATTERN

        def on_send(node)
          return unless cop_config['NotPresent']

          not_present?(node) do |receiver|
            add_offense(node,
                        :expression,
                        format(MSG_NOT_PRESENT,
                               replacement(receiver),
                               node.source))
          end
        end

        def on_or(node)
          return unless cop_config['NilOrEmpty']
          return unless node.lhs.receiver && node.rhs.receiver

          nil_or_empty?(node) do |variable1, variable2|
            return unless variable1 == variable2

            add_offense(node,
                        :expression,
                        format(MSG_NIL_OR_EMPTY, variable1.source, node.source))
          end
        end

        def on_if(node)
          return unless cop_config['UnlessPresent']
          return unless node.unless?

          unless_present?(node) do |method_call, receiver|
            range = unless_condition(node, method_call)

            add_offense(node,
                        range,
                        format(MSG_UNLESS_PRESENT,
                               receiver.source,
                               range.source))
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            method_call, variable1 = unless_present?(node)

            if method_call && variable1
              corrector.replace(node.loc.keyword, 'if')
              range = method_call.loc.expression
            else
              variable1, _variable2 = nil_or_empty?(node) || not_present?(node)
              range = node.loc.expression
            end

            corrector.replace(range, replacement(variable1))
          end
        end

        private

        def unless_condition(node, method_call)
          if node.modifier_form?
            node.loc.keyword.join(node.loc.expression.end)
          else
            node.loc.expression.begin.join(method_call.loc.expression)
          end
        end

        def replacement(node)
          node.respond_to?(:source) ? "#{node.source}.blank?" : 'blank?'
        end
      end
    end
  end
end
