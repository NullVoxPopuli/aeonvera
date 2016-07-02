class StripeRefund
  alias :read_attribute_for_serialization :send
  attr_accessor :id, :amount, :created, :status

  def initialize(attributes)
    @id = attributes['id']
    @amount = attributes['amount']
    @created = attributes['created']
    @status = attributes['status']
  end

  def self.model_name
    @_model_name ||= ActiveModel::Name.new(self)
  end
end
