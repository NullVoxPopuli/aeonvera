# frozen_string_literal: true

# == Schema Information
#
# Table name: restraints
#
#  dependable_id     :integer
#  dependable_type   :string(255)
#  restrictable_id   :integer
#  restrictable_type :string(255)
#  id                :integer          not null, primary key
#
# Indexes
#
#  index_restraints_on_dependable_id_and_dependable_type      (dependable_id,dependable_type)
#  index_restraints_on_restrictable_id_and_restrictable_type  (restrictable_id,restrictable_type)
#

class Restraint < ApplicationRecord
  # a discount would be a restrictable item that is
  # dependent on a package
  #
  # a pricieng tier would be a restrictable item that
  # is dependent on a package
  belongs_to :dependable, polymorphic: true
  belongs_to :restrictable, polymorphic: true

  validates :dependable, presence: true
  validates :restrictable, presence: true
end
