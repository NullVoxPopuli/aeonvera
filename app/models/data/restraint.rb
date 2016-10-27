class Restraint < ActiveRecord::Base
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
