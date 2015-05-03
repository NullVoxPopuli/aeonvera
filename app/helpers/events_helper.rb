module EventsHelper

  def housing_form_options
    {
      Event::HOUSING_DISABLED => "Disabled",
      Event::HOUSING_ENABLED => "Applicants can apply",
      Event::HOUSING_CLOSED => "No new applicants"
    }
  end

  def days_of_the_week
    result = []
    Date::DAYNAMES.each_with_index{ |day, index|
      result << [index, day]
    }
    result
  end

  # = f.select options_for_select(attendee_options)
  def attendee_options
    @event.attendees.map{ |a| [a.name, a.id] }
  end

  def attendance_options
    @event.attendances.map { |a| [a.attendee_name, a.id] }.sort{ |a, b| a[0] <=> b[0] }
  end

  def short_date_for_event(event)

    start = event.starts_at.to_date.to_s(:short)
    finish = event.ends_at.to_date.to_s(:short)

    "#{start} - #{finish}"
  end

  def event_registration_path(event)
    subdomain = event.subdomain
    "#{request.protocol}#{subdomain}.#{request.host_with_port.gsub("www.", "")}#"
  end
end
