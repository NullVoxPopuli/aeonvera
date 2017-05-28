module CurrentSubdomain
  extend ActiveSupport::Concern

  # account for nested subdomains
  # events will only use the bottom most subdomain
  def current_subdomain
    request.subdomain.gsub(/\.#{APPLICATION_CONFIG[:domain][Rails.env].split(".").first}/, "")
  end
end
