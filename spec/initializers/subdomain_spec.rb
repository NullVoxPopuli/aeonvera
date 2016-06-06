require 'spec_helper'

describe Subdomain do
  describe '#redirect_url_for' do
    APPLICATION_CONFIG['domain'].each do |env_name, domain|
      before(:each) do
        allow(Subdomain).to receive(:current_domain) { domain }
      end

      context env_name do
        it 'redirects' do
          requested_url = "https://subdomain1.#{domain}"
          result = Subdomain.redirect_url_for(requested_url, domain)
          expect(result).to eq "https://#{domain}/subdomain1"
        end

        it 'works without a protocol' do
          requested_url = "subdomain2.#{domain}"
          result = Subdomain.redirect_url_for(requested_url, domain)
          expect(result).to eq "https://#{domain}/subdomain2"
        end

        it 'does nothing when there is no subdomain' do
          requested_url = "http://#{domain}"
          result = Subdomain.redirect_url_for(requested_url, domain)
          expect(result).to eq nil
        end

        it 'does nothing when there is a path and no subdomain' do
          requested_url = "http://#{domain}/path/to/something"
          result = Subdomain.redirect_url_for(requested_url, domain)
          expect(result).to eq nil
        end

        it 'respects the protocol' do
          requested_url = "http://subdomain2.#{domain}"
          result = Subdomain.redirect_url_for(requested_url, domain)
          expect(result).to eq "http://#{domain}/subdomain2"
        end

        it 'removes the path' do
          requested_url = "http://subdomain3.#{domain}/this/does/not/matter"
          result = Subdomain.redirect_url_for(requested_url, domain)
          expect(result).to eq "http://#{domain}/subdomain3"
        end
      end
    end
  end
end
