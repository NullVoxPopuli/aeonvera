# Based on https://github.com/thoughtbot/factory_girl/
#          wiki/Testing-all-Factories-(with-RSpec)
require 'spec_helper'

RSpec.describe FactoryGirl do
  described_class.factories.map(&:name).each do |factory_name|
    describe "#{factory_name} factory" do
      it 'is valid' do
        factory = described_class.build(factory_name)
        expect(factory)
          .to be_valid, -> { factory.errors.full_messages.join("\n") }
      end
    end
  end
end
