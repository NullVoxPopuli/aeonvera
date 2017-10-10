# frozen_string_literal: true

require 'rails_helper'

describe Api::MembersController, type: :request do
  include RequestSpecUserSetup

  context 'not logged in' do
    it 'searches for a user' do
      get '/api/members?q[first_name_eq]=something'
      expect(response.status).to eq 401
    end
  end

  context 'logged in' do
    context 'manages an organization' do
      it 'can search for a user' do
        get '/api/members/all?q[first_name_eq]=something', {}, auth_header_for(owner)
        expect(response.status).to eq 200
      end

      # TODO: move some of this to a csv_generation spec
      it 'can download a csv' do
        option = create(:membership_option, organization: organization)
        create(:membership_renewal, user: stray_user, membership_option: option)

        get "/api/members.csv?organization_id=#{organization.id}", {}, auth_header_for(owner)
        expect(response.status).to eq 200

        csv_data = response.body
        csv = CSV.parse(csv_data, headers: true)
        first_user = csv.first.to_hash
        expected = {
          'first_name'            => stray_user.first_name,
          'last_name'             => stray_user.last_name,
          'email'                 => stray_user.email,
          'is_active_member'      => stray_user.is_member_of?(organization).to_s,
          'member_since'          => stray_user.member_since(organization).iso8601,
          'membership_expires_at' => stray_user.membership_expires_at(organization).iso8601
        }
        expect(first_user).to eq expected
      end
    end

    context 'does not manage an organization' do
    end
  end
end
