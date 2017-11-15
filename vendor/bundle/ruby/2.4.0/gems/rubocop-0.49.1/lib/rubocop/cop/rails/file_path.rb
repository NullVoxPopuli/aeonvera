# frozen_string_literal: true

module RuboCop
  module Cop
    module Rails
      # This cop is used to identify usages of file path joining process
      # to use `Rails.root.join` clause.
      #
      # @example
      #  # bad
      #  Rails.root.join('app/models/goober')
      #  File.join(Rails.root, 'app/models/goober')
      #  "#{Rails.root}/app/models/goober"
      #
      #  # good
      #  Rails.root.join('app', 'models', 'goober')
      class FilePath < Cop
        MSG = 'Please use `Rails.root.join(\'path\', \'to\')` instead.'.freeze

        def_node_matcher :file_join_nodes?, <<-PATTERN
          (send (const nil :File) :join ...)
        PATTERN

        def_node_search :rails_root_nodes?, <<-PATTERN
          (send (const nil :Rails) :root)
        PATTERN

        def_node_matcher :rails_root_join_nodes?, <<-PATTERN
          (send (send (const nil :Rails) :root) :join ...)
        PATTERN

        def on_dstr(node)
          return unless rails_root_nodes?(node)
          register_offense(node)
        end

        def on_send(node)
          check_for_file_join_with_rails_root(node)
          check_for_rails_root_join_with_slash_separated_path(node)
        end

        private

        def check_for_file_join_with_rails_root(node)
          return unless file_join_nodes?(node)
          return unless node.method_args.any? { |e| rails_root_nodes?(e) }

          register_offense(node)
        end

        def check_for_rails_root_join_with_slash_separated_path(node)
          return unless rails_root_nodes?(node)
          return unless rails_root_join_nodes?(node)
          return unless node.method_args.any? { |arg| string_with_slash?(arg) }

          register_offense(node)
        end

        def string_with_slash?(node)
          node.str_type? && node.source =~ %r{/}
        end

        def register_offense(node)
          line_range = node.loc.column...node.loc.last_column

          add_offense(
            node,
            source_range(processed_source.buffer, node.loc.line, line_range),
            MSG
          )
        end
      end
    end
  end
end
