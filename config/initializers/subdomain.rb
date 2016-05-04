class Subdomain
  def self.matches?(request)
    subdomain = request.subdomain
    # in the case of nested subdomains, such as
    # sub.domain.com:3000

    return false if current_domain.split(".").first == subdomain
    return false if subdomain == 'aeonvera'
    # get the left most subdomain
    subdomain = subdomain.split(".").first
    case subdomain
    when "", nil
      false
    else
      true
    end
  end

  def self.current_domain
    APPLICATION_CONFIG[:domain][Rails.env]
  end

  def self.redirect_url_for(url, domain = current_domain)
    protocol, url = url.split('://')

    if url.nil?
      url = protocol
      protocol = 'https'
    end

    return if url.starts_with?(domain)
    subdomain, path = url.split('.' + domain)
    subdomain = '' if subdomain == 'www'

    "#{protocol}://#{domain}/#{subdomain}"
  end
end
