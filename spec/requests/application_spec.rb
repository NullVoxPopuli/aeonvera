require 'spec_helper'

describe 'Subdomains not allowed', type: :request do

  context 'GET subdomain.whatever' do
    let(:domain) { APPLICATION_CONFIG['domain'][Rails.env] }

    it 'redirects' do
      get "https://subdomain1.#{domain}"
      expect(response.status).to eq 301
      expect(response.location).to eq "https://#{domain}/subdomain1"
    end

    it 'respects the protocol' do
      get "http://subdomain2.#{domain}"
      expect(response.status).to eq 301
      expect(response.location).to eq "http://#{domain}/subdomain2"
    end

    it 'removes the path' do
      get "http://subdomain3.#{domain}/this/does/not/matter"
      expect(response.status).to eq 301
      expect(response.location).to eq "http://#{domain}/subdomain3"
    end

    it 'trims www' do
      get "http://www.#{domain}/"
      expect(response.status).to eq 301
      expect(response.location).to eq "http://#{domain}/"
    end
  end
end
