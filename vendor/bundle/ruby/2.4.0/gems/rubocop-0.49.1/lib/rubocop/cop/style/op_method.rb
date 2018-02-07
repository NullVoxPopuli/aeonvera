# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # This cop makes sure that certain binary operator methods have their
      # sole  parameter named `other`.
      #
      # @example
      #
      #   # bad
      #   def +(amount); end
      #
      #   # good
      #   def +(other); end
      class OpMethod < Cop
        MSG = 'When defining the `%s` operator, ' \
              'name its argument `other`.'.freeze

        OP_LIKE_METHODS = %i[eql? equal?].freeze
        BLACKLISTED = %i[+@ -@ [] []= << `].freeze

        def_node_matcher :op_method_candidate?, <<-PATTERN
          (def $_ (args $(arg [!:other !:_other])) _)
        PATTERN

        def on_def(node)
          op_method_candidate?(node) do |name, arg|
            return unless op_method?(name)
            add_offense(arg, :expression, format(MSG, name))
          end
        end

        def op_method?(name)
          return false if BLACKLISTED.include?(name)
          name !~ /\A\w/ || OP_LIKE_METHODS.include?(name)
        end
      end
    end
  end
end
