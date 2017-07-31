# frozen_string_literal: true
require 'spec_helper'

describe Api::HostOperations do
  describe Api::HostOperations::Read do
    context 'model_from_params' do
      let(:subdomain) { 'subdomain' }
      let(:operation) { Api::HostOperations::Read.new(nil, { subdomain: subdomain }) }

      it 'finds an event' do
        event = create(:event, domain: subdomain)
        model = operation.run
        expect(model).to eq event
      end

      it 'finds an organization' do
        org = create(:organization, domain: subdomain)
        model = operation.run
        expect(model).to eq org
      end

      it 'finds nothing' do
        model = operation.run
        expect(model).to be_nil
      end
    end
  end
end
