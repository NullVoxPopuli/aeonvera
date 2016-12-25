# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: APPLICATION_CONFIG['support_email']
  layout 'email'

  def arbre(header, &block)
    content_for(:header) { header }
    Arbre::Context.new(&block).to_s
  end

  def slim(header, slim_string)
    content_for(:header) { header }
    slim_string
  end
end
