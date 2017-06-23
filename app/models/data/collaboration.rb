# frozen_string_literal: true
# == Schema Information
#
# Table name: collaborations
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  collaborated_id   :integer
#  title             :string(255)
#  permissions       :text
#  deleted_at        :datetime
#  created_at        :datetime
#  updated_at        :datetime
#  collaborated_type :string(255)
#
# Indexes
#
#  index_collaborations_on_collaborated_id_and_collaborated_type  (collaborated_id,collaborated_type)
#  index_collaborations_on_user_id                                (user_id)
#

# Collaborator < Admin < Owner
# Owners cannot be callaborators, as they'll have a relationship set
# on the object they are trying to mess with
class Collaboration < ApplicationRecord
  include SoftDeletable
  serialize :permissions, JSON

  belongs_to :collaborated, polymorphic: true
  belongs_to :user

  validates :collaborated, presence: true
  validates :user, presence: true
end
