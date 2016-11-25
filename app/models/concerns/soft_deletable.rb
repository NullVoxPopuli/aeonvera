# frozen_string_literal: true
module SoftDeletable
  extend ActiveSupport::Concern

  included do
    acts_as_paranoid
  end
end
