class Subdomain
  def self.matches?(request)
    subdomain = request.subdomain
    # in the case of nested subdomains, such as
    # sub.domain.com:3000

    return false if current_domain == subdomain
    return false if subdomain == 'aeonvera'
    # get the left most subdomain
    subdomain = subdomain.split(".").first
    case subdomain
    when "www", "#{APPLICATION_CONFIG["admin_subdomain"]}", "", nil
      false
    else
      true
    end
  end

  def self.current_domain
    APPLICATION_CONFIG[:domain][Rails.env].split(".").first
  end

  # An event's subdomain is freed once the event is over
  def self.is_event?(subdomain)
    table = Event.arel_table
    ends_at = table[:ends_at]
    now = Time.now
    Event.where(ends_at.gt(now)).find_by_subdomain(subdomain).present?
  end

  def self.is_organization?(subdomain)
    Organization.find_by_subdomain(subdomain).present?
  end

end
