class CompetitionResponse < ActiveRecord::Base
  include SoftDeletable

  belongs_to :competition
  belongs_to :attendance, polymorphic: true
end
