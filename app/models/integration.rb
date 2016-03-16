# the entire config is encrypted, but since the whole config gets loaded (and decrypted)
# all at once, if anyone figures out how to read to read the RAM of our system, we don't
# want the clear text version of the password floating around.
#
# The :password should be encrypted in the config. (currently it is not)
class Integration < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  ENCRYPTION_KEY = "aeonvera_integrations"

  attr_encrypted :config, :key => ENCRYPTION_KEY, :marshal => true

  STRIPE = "stripe"
  PAYPAL = "paypal"

  validates :kind, presence: true
  validates :owner, presence: true


  # allows public access to attr_encrypted (which is protected)
  # this is required for migration :(
  def self.encrypted(*args)
    attr_encrypted(*args)
  end

  def self.options
    attr_encrypted_options
  end
end
