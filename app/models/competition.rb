class Competition < ActiveRecord::Base
	include HasMetadata
	include SoftDeletable

	belongs_to :user
	belongs_to :event


	has_and_belongs_to_many :attendances,
		-> { where(attending: true).order("attendances.created_at DESC") },
		join_table: "attendances_competitions",
		association_foreign_key: "attendance_id", foreign_key: "competition_id"

	SOLO_JAZZ = 0
	JACK_AND_JILL = 1
	STRICTLY = 2
	TEAM = 3
	CROSSOVER_JACK_AND_JILL = 4

	KIND_NAMES = {
		SOLO_JAZZ => "Solo Jazz",
		JACK_AND_JILL => "Jack & Jill",
		STRICTLY => "Strictly",
		TEAM => "Team",
		CROSSOVER_JACK_AND_JILL => "Crossover Jack & Jill"
	}

	def kind_name
		KIND_NAMES[kind]
	end

	def current_price
		self.initial_price
	end

	def to_competitor_csv(options = {})
		CSV.generate(options) do |csv|
			csv << ["Competition Number", "Name", "Dance Orientation"]#, "City", "State"]
			attendances.reorder(created_at: :asc).each do |attendance|
				row = [
					"",
					attendance.attendee_name,
					attendance.dance_orientation
					# attendance.address["city"],
					# attendance.address["state"]
				]
				csv << row
			end
		end
	end
end
