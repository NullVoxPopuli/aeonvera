# frozen_string_literal: true

module RuboCop
  module Cop
    module Layout
      # This cops checks the indentation of the here document bodies. The bodies
      # are indented one step.
      # In Ruby 2.3 or newer, squiggly heredocs (`<<~`) should be used. If you
      # use the older rubies, you should introduce some library to your project
      # (e.g. ActiveSupport, Powerpack or Unindent).
      #
      # @example
      #
      #   # bad
      #   <<-END
      #   something
      #   END
      #
      #   # good
      #   # When EnforcedStyle is squiggly, bad code is auto-corrected to the
      #   # following code.
      #   <<~END
      #     something
      #   END
      #
      #   # good
      #   # When EnforcedStyle is active_support, bad code is auto-corrected to
      #   # the following code.
      #   <<-END.strip_heredoc
      #     something
      #   END
      class IndentHeredoc < Cop
        include ConfigurableEnforcedStyle
        include SafeMode

        RUBY23_MSG = 'Use %d spaces for indentation in a heredoc by using ' \
                     '`<<~` instead of `%s`.'.freeze
        LIBRARY_MSG = 'Use %d spaces for indentation in a heredoc by using %s.'
                      .freeze
        StripMethods = {
          unindent: 'unindent',
          active_support: 'strip_heredoc',
          powerpack: 'strip_indent'
        }.freeze

        def on_str(node)
          return unless heredoc?(node)

          body_indent_level = body_indent_level(node)

          if heredoc_indent_type(node) == '~'
            expected_indent_level = base_indent_level(node) + indentation_width
            return if expected_indent_level == body_indent_level
          else
            return unless body_indent_level.zero?
          end

          add_offense(node, :heredoc_body)
        end

        alias on_dstr on_str
        alias on_xstr on_str

        def autocorrect(node)
          check_style!

          case style
          when :squiggly
            correct_by_squiggly(node)
          else
            correct_by_library(node)
          end
        end

        private

        def style
          style = super
          return style unless style == :auto_detection

          if target_ruby_version >= 2.3
            :squiggly
          elsif rails?
            :active_support
          end
        end

        def message(node)
          case style
          when :squiggly
            current_indent_type = "<<#{heredoc_indent_type(node)}"
            format(RUBY23_MSG, indentation_width, current_indent_type)
          when nil
            method = "some library(e.g. ActiveSupport's `String#strip_heredoc`)"
            format(LIBRARY_MSG, indentation_width, method)
          else
            method = "`String##{StripMethods[style]}`"
            format(LIBRARY_MSG, indentation_width, method)
          end
        end

        def correct_by_squiggly(node)
          return if target_ruby_version < 2.3
          lambda do |corrector|
            if heredoc_indent_type(node) == '~'
              corrector.replace(node.loc.heredoc_body, indented_body(node))
            else
              heredoc_beginning = node.loc.expression.source
              corrected = heredoc_beginning.sub(/<<-?/, '<<~')
              corrector.replace(node.loc.expression, corrected)
            end
          end
        end

        def correct_by_library(node)
          lambda do |corrector|
            corrector.replace(node.loc.heredoc_body, indented_body(node))
            corrected = ".#{StripMethods[style]}"
            corrector.insert_after(node.loc.expression, corrected)
          end
        end

        def check_style!
          case style
          when nil
            raise Warning, "Auto-correction does not work for #{cop_name}. " \
                           'Please configure EnforcedStyle.'
          when :squiggly
            if target_ruby_version < 2.3
              raise Warning, '`squiggly` style is selectable only on Ruby ' \
                             "2.3 or higher for #{cop_name}."
            end
          end
        end

        def heredoc?(node)
          node.loc.is_a?(Parser::Source::Map::Heredoc)
        end

        def indented_body(node)
          body = node.loc.heredoc_body.source
          body_indent_level = body_indent_level(node)
          correct_indent_level = base_indent_level(node) + indentation_width
          body.gsub(/^\s{#{body_indent_level}}/, ' ' * correct_indent_level)
        end

        def body_indent_level(node)
          body = node.loc.heredoc_body.source
          indent_level(body)
        end

        def base_indent_level(node)
          base_line_num = node.loc.expression.line
          base_line = processed_source.lines[base_line_num - 1]
          indent_level(base_line)
        end

        def indent_level(str)
          str.scan(/^\s*/).reject { |line| line == "\n" }.min_by(&:size).size
        end

        # Returns '~', '-' or nil
        def heredoc_indent_type(node)
          node.source[/^<<([~-])/, 1]
        end

        def indentation_width
          @config.for_cop('IndentationWidth')['Width'] || 2
        end
      end
    end
  end
end
