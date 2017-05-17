# frozen_string_literal: true

require 'reform/form/dry'

Reform::Form.class_eval do
  include Reform::Form::Dry
end
