# frozen_string_literal: true

# == Schema Information
#
# Table name: integrations
#
#  id               :integer          not null, primary key
#  kind             :string(255)
#  encrypted_config :text
#  owner_id         :integer
#  owner_type       :string(255)
#
# Indexes
#
#  index_integrations_on_owner_id_and_owner_type  (owner_id,owner_type)
#

# the entire config is encrypted, but since the whole config gets loaded (and decrypted)
# all at once, if anyone figures out how to read to read the RAM of our system, we don't
# want the clear text version of the password floating around.
#
# The :password should be encrypted in the config. (currently it is not)
class Integration < ApplicationRecord
  belongs_to :owner, polymorphic: true

  ENCRYPTION_KEY = 'aeonvera_integrations'

  # TODO: fix/upgrade need iv column :-\
  attr_encrypted :config, key: ENCRYPTION_KEY,
                          marshal: true,
                          insecure_mode: true

  STRIPE = 'stripe'
  PAYPAL = 'paypal'

  validates :kind, presence: true
  validates :owner, presence: true
  validate :validate_publishable_key

  # allows public access to attr_encrypted (which is protected)
  # this is required for migration :(
  def self.encrypted(*args)
    attr_encrypted(*args)
  end

  def self.options
    attr_encrypted_options
  end

  private

  def validate_publishable_key
    if kind == Integration::STRIPE
      key = config.try(:[], 'stripe_publishable_key')
      !!key
    end
  end
end
