require 'spec_helper'

describe EventDecorator do

  before(:each) do
    @event = create(:event)
    @event_decorator = @event.decorate
  end

  describe '#revenue' do
    it 'has no revenue' do
      expect(@event_decorator.revenue).to eq 0
    end
  end

  describe '#unpaid' do
    it 'has no no registrants' do
      expect(@event_decorator.unpaid).to eq 0
    end
  end

  describe '#total_registrants' do
    it 'has no registrants' do
      expect(@event_decorator.total_registrants).to eq 0
    end
  end

  describe '#total_follows' do
    it 'has no registrants' do
      expect(@event_decorator.total_leads).to eq 0
    end
  end

  describe '#total_leads' do
    it 'has no registrants' do
      expect(@event_decorator.total_leads).to eq 0
    end
  end

end
