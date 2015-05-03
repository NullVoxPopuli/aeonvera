class SubdomainBelongsToEvent
  # it is safe to assume we aren't in a restricted
  # domain, due to the higher level subdomain constraint
  # occuring before this one
  def self.matches?(request)
    subdomain = request.subdomain

    # get the list most subdomain
    subdomain = subdomain.split('.').first

    # do we belong to an event?
    return Event.where(domain: subdomain).first.present?
  end


end
