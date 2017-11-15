# -*- encoding: utf-8 -*-
# stub: fuubar 2.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "fuubar".freeze
  s.version = "2.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://rubygems.org" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Nicholas Evans".freeze, "Jeff Kreeftmeijer".freeze, "jfelchner".freeze]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDrjCCApagAwIBAgIBATANBgkqhkiG9w0BAQUFADBOMRowGAYDVQQDDBFhY2Nv\ndW50c19ydWJ5Z2VtczEbMBkGCgmSJomT8ixkARkWC3RoZWtvbXBhbmVlMRMwEQYK\nCZImiZPyLGQBGRYDY29tMB4XDTE2MDQyNDAyNTEyM1oXDTE3MDQyNDAyNTEyM1ow\nTjEaMBgGA1UEAwwRYWNjb3VudHNfcnVieWdlbXMxGzAZBgoJkiaJk/IsZAEZFgt0\naGVrb21wYW5lZTETMBEGCgmSJomT8ixkARkWA2NvbTCCASIwDQYJKoZIhvcNAQEB\nBQADggEPADCCAQoCggEBANklzdaVeHtut6LTe/hrl6Krz2Z60InEbNb+TMG43tww\njBpWZrdU/SBkR3EYbTAQv/yGTuMHoVKGK2kDlFvdofW2hX0d14qPyYJUNYt+7VWE\n3UhPSxw1i6MxeU1QwfkIyaN8A5lj0225+rwI/mbplv+lSXPlJEroCQ9EfniZD4jL\nURlrHWl/UejcQ32C1IzBwth3+nacrO1197v5nSdozFzQwm4groaggXn9F/WpThu+\nMhcE4bfttwEjAfU3zAThyzOFoVPpACP+SwOuyPJSl02+9BiwzeAnFJDfge7+rsd5\n64W/VzBIklEKUZMmxZwr5DwpSXLrknBDtHLABG9Nr3cCAwEAAaOBljCBkzAJBgNV\nHRMEAjAAMAsGA1UdDwQEAwIEsDAdBgNVHQ4EFgQUP7v0f/qfa0LMrhkzHRI3l10X\nLYIwLAYDVR0RBCUwI4EhYWNjb3VudHMrcnVieWdlbXNAdGhla29tcGFuZWUuY29t\nMCwGA1UdEgQlMCOBIWFjY291bnRzK3J1YnlnZW1zQHRoZWtvbXBhbmVlLmNvbTAN\nBgkqhkiG9w0BAQUFAAOCAQEASqdfJKMun1twosHfvdDH7Vgrb5VqX28qJ6MgnhjF\np+3HYTjYo/KMQqu78TegUFO5xQ4oumU0FTXADW0ryXZvUGV74M0zwqpFqeo8onII\nlsVsWdMCLZS21M0uCQmcV+OQMNxL8jV3c0D3x9Srr9yO4oamW3seIdb+b9RfhmV2\nryr+NH8U/4xgzdJ4hWV4qk93nwigp4lwJ4u93XJ7Cdyw7itvaEPnn8HpCfzsiLcw\nQwSfDGz6+zsImi5N3UT71+mk7YcviQSgvMRl3VkAv8MZ6wcJ5SQRpf9w0OeFH6Ln\nnNbCoHiYeXX/lz/M6AIbxDIZZTwxcyvF7bdrQ2fbH5MsfQ==\n-----END CERTIFICATE-----\n".freeze]
  s.date = "2016-08-23"
  s.description = "the instafailing RSpec progress bar formatter".freeze
  s.email = "[\"jeff@kreeftmeijer.nl\", \"accounts+git@thekompanee.com\"]".freeze
  s.homepage = "https://github.com/thekompanee/fuubar".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.2".freeze
  s.summary = "the instafailing RSpec progress bar formatter".freeze

  s.installed_by_version = "2.7.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rspec-core>.freeze, ["~> 3.0"])
      s.add_runtime_dependency(%q<ruby-progressbar>.freeze, ["~> 1.4"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<chamber>.freeze, ["~> 2.3"])
      s.add_development_dependency(%q<awesome_print>.freeze, ["~> 1.7"])
    else
      s.add_dependency(%q<rspec-core>.freeze, ["~> 3.0"])
      s.add_dependency(%q<ruby-progressbar>.freeze, ["~> 1.4"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_dependency(%q<chamber>.freeze, ["~> 2.3"])
      s.add_dependency(%q<awesome_print>.freeze, ["~> 1.7"])
    end
  else
    s.add_dependency(%q<rspec-core>.freeze, ["~> 3.0"])
    s.add_dependency(%q<ruby-progressbar>.freeze, ["~> 1.4"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<chamber>.freeze, ["~> 2.3"])
    s.add_dependency(%q<awesome_print>.freeze, ["~> 1.7"])
  end
end
