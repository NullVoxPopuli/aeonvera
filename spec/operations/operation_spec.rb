require 'spec_helper'


describe Operations::OrderLineItem do
  let(:klass){Operations::OrderLineItem::Read}

  context :instantiation do
    it 'sets accessors' do
      user = User.new
      params = {a: :b}
      operation = klass.new(user, params)
      expect(operation.current_user).to eq user
      expect(operation.params).to eq params
    end
  end

  describe :object_class do
    it 'determines the object class' do
      op = klass.new(nil, nil)
      expect(op.object_class).to eq OrderLineItem
    end
  end

  describe :object_type_of_interest do
    it 'determines the object class name' do
      op = klass.new(nil, nil)
      expect(op.object_type_of_interest).to eq OrderLineItem.name
    end
  end

  describe :policy_class do
    it 'derives the class for the policy' do
      op = klass.new(nil, nil)
      expect(op.policy_class).to eq Policies::OrderLineItemPolicy
    end
  end

  describe :policy_name do
    it 'derives the policy name from the operation name' do
      op = klass.new(nil, nil)
      expect(op.policy_name).to eq 'read?'
    end
  end

  describe :allowed_for? do
    it 'invokes the policy name' do
      op = klass.new(nil, nil)
      name = op.policy_name
      policy = ::Policies::OrderLineItemPolicy.new(nil, nil)

      allow(op).to receive(:policy_for){ policy }
      allow(policy).to receive(:read?)
      expect(policy).to receive(:read?)

      # object doesn't matter here, cause we don't care about the value
      # of the policy
      op.allowed_for?(nil)
    end
  end

end
