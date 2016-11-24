# frozen_string_literal: true
# Collaborator < Admin < Owner
# Owners cannot be callaborators, as they'll have a relationship set
# on the object they are trying to mess with
class Collaboration < ActiveRecord::Base
  include SoftDeletable
  serialize :permissions, JSON

  belongs_to :collaborated, polymorphic: true
  belongs_to :user

  validates :collaborated, presence: true
  validates :user, presence: true
end
