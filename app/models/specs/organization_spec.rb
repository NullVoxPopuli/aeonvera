# frozen_string_literal: true
# == Schema Information
#
# Table name: organizations
#
#  id                         :integer          not null, primary key
#  name                       :string(255)
#  tagline                    :string(255)
#  city                       :string(255)
#  state                      :string(255)
#  beta                       :boolean          default(FALSE), not null
#  owner_id                   :integer
#  deleted_at                 :datetime
#  created_at                 :datetime
#  updated_at                 :datetime
#  domain                     :string(255)
#  make_attendees_pay_fees    :boolean
#  logo_file_name             :string(255)
#  logo_content_type          :string(255)
#  logo_file_size             :integer
#  logo_updated_at            :datetime
#  notify_email               :string
#  email_all_purchases        :boolean          default(FALSE), not null
#  email_membership_purchases :boolean          default(FALSE), not null
#  contact_email              :string
#  website                    :string
#
# Indexes
#
#  index_organizations_on_domain  (domain)
#

require 'spec_helper'

describe Organization do
  before(:each) do
    @organization = create(:organization)
  end

  describe '#available_dances' do
    it 'returns nothing when registration has not started' do
      create(:dance, host: @organization, registration_opens_at: 2.weeks.from_now)

      result = @organization.available_dances.count
      expect(result).to eq 0
    end

    it 'returns nothing when registration is closed' do
      create(:dance, host: @organization, registration_closes_at: 2.weeks.ago)

      result = @organization.available_dances.count
      expect(result).to eq 0
    end

    it 'returns a dance that has no dates' do
      dance = create(:dance, host: @organization)

      result = @organization.available_dances
      expect(result).to include(dance)
      expect(result.count).to eq 1
    end

    it 'returns a dance that is open with both dates' do
      dance = create(:dance, host: @organization,
                             registration_opens_at: 2.weeks.ago,
                             registration_closes_at: 2.weeks.from_now)

      result = @organization.available_dances
      expect(result).to include(dance)
      expect(result.count).to eq 1
    end
  end

  describe '#available_lessons' do
    it 'returns nothing when registration has not started' do
      create(:lesson, host: @organization, registration_opens_at: 2.weeks.from_now)

      result = @organization.available_lessons.count
      expect(result).to eq 0
    end

    it 'returns nothing when registration is closed' do
      create(:lesson, host: @organization, registration_closes_at: 2.weeks.ago)

      result = @organization.available_lessons.count
      expect(result).to eq 0
    end

    it 'returns a lesson that has no dates' do
      lesson = create(:lesson, host: @organization,
                               registration_opens_at: nil, registration_closes_at: nil)

      result = @organization.available_lessons.to_a
      expect(result).to include(lesson)
      expect(result.count).to eq 1
    end

    it 'returns a lesson that is open with both dates' do
      lesson = create(:lesson, host: @organization,
                               registration_opens_at: 2.weeks.ago,
                               registration_closes_at: 2.weeks.from_now)

      result = @organization.available_lessons
      expect(result).to include(lesson)
      expect(result.count).to eq 1
    end
  end
end
