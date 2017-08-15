# frozen_string_literal: true

module OwnershipChecks
  extend ActiveSupport::Concern

  def is_at_least_a_collaborator?(of = object.try(:host))
    (of && of.collaborator_ids.include?(user.id)) || is_owner?(of)
  end

  def is_owner?(of = object.try(:host))
    id = of.try(:hosted_by_id) || of.try(:owner_id)
    id == user.id
  end
end
