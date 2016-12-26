# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: APPLICATION_CONFIG['support_email']
  layout 'email'

  def arbre(header, &block)
    content_for(:header) { header }
    Arbre::Context.new(&block).to_s
  end

  def slim(source, options = {}, &block)
    scope = options.delete(:scope)
    locals = options.delete(:locals)
    Slim::Template.new('', {}) { source }.render(scope, locals, &block)
  end
end
