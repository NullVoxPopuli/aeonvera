require 'mongoid_spec_helper'

module Ransack
  module Nodes
    describe Condition do

      context 'with an alias' do
        subject {
          Condition.extract(
            Context.for(Person), 'term_start', Person.first(2).map(&:name)
          )
        }

        specify { expect(subject.combinator).to eq 'or' }
        specify { expect(subject.predicate.name).to eq 'start' }

        it 'converts the alias to the correct attributes' do
          expect(subject.attributes.map(&:name)).to eq(['name', 'email'])
        end
      end

      context 'with multiple values and an _any predicate' do
        subject { Condition.extract(Context.for(Person), 'name_eq_any', Person.first(2).map(&:name)) }

        specify { expect(subject.values.size).to eq(2) }
      end

      context 'with an invalid predicate' do
        subject { Condition.extract(Context.for(Person), 'name_invalid', Person.first.name) }

        context "when ignore_unknown_conditions is false" do
          before do
            Ransack.configure { |config| config.ignore_unknown_conditions = false }
          end

          specify { expect { subject }.to raise_error ArgumentError }
        end

        context "when ignore_unknown_conditions is true" do
          before do
            Ransack.configure { |config| config.ignore_unknown_conditions = true }
          end

          specify { expect(subject).to be_nil }
        end
      end
    end
  end
end
