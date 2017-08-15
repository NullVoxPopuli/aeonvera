# frozen_string_literal: true

require 'render_anywhere'
class ApplicationMailer < ActionMailer::Base
  default from: APPLICATION_CONFIG['support_email']

  layout 'email'

  def arbre(env: {})
    raise 'No Block Given' unless block_given?

    RenderAnywhere::RenderingController.new.render_to_string(
      inline: yield, layout: 'email', type: :arbre, locals: env
    )
  end

  def slim(env: {})
    raise 'No Block Given' unless block_given?

    RenderAnywhere::RenderingController.new.render_to_string(
      inline: yield, layout: 'email', type: :slim, locals: env
    )
  end
end
