module AttendanceDownloadableData
  extend ActiveSupport::Concern

  module ClassMethods

    def to_csv(options = {})
      CSV.generate(options) do |csv|
        csv << ["Name", "Email", "Registered At", "City", "State"]
        all.each do |attendance|
          row = [
            attendance.attendee_name,
            attendance.attendee.email,
            attendance.created_at,
            attendance.address["city"],
            attendance.address["state"]
          ]
          csv << row
        end
      end
    end

    def to_volunteer_csv(options = {})
      to_csv(options)
    end

    def to_providing_housing_csv(options = {})
      CSV.generate(options) do |csv|
        csv << [
          "Name",
          "Email",
          "Date Registered",
          "Roommate Gender Preferences",
          "Requires Transportation",
          "Allergies",
          "Smoking Preferences",
          "Notes"
        ]
        all.each do |attendance|
          housing = attendance.requested_housing_data
          row = [
            attendance.attendee_name,
            attendance.attendee.email,
            attendance.created_at.to_date.to_s(:long),
            housing["gender"],
            housing["transportation"].to_b,
            housing["allergies"],
            housing["smoking"],
            housing["notes"]
          ]
          csv << row
        end
      end
    end

    def to_requesting_housing_csv(options = {})
      CSV.generate(options) do |csv|
        csv << [
          "Name",
          "Email",
          "Date Registered",
          "Housing Gender Preferences",
          "Has Room for # People",
          "Offering Transportation",
          "Can Transport # People",
          "Smoking Present",
          "Has Pets"
        ]
        all.each do |attendance|
          housing = attendance.requested_housing_data
          row = [
            attendance.attendee_name,
            attendance.attendee.email,
            attendance.created_at.to_date.to_s(:long),
            housing["gender"],
            housing["room_for"],
            housing["transportation"].to_b,
            housing["transportation_for"],
            housing["smoking"],
            housing["have_pets"].to_b
          ]
          csv << row
        end
      end
    end
  end
end
