# frozen_string_literal: true

module RuboCop
  module Cop
    module Layout
      # Checks for comma (,) not followed by some kind of space.
      class SpaceAfterComma < Cop
        include SpaceAfterPunctuation

        def space_style_before_rcurly
          cfg = config.for_cop('Layout/SpaceInsideHashLiteralBraces')
          cfg['EnforcedStyle'] || 'space'
        end

        def kind(token)
          'comma' if token.type == :tCOMMA
        end
      end
    end
  end
end
