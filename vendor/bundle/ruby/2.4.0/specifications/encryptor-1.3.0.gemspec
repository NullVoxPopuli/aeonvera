# -*- encoding: utf-8 -*-
# stub: encryptor 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "encryptor".freeze
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sean Huber".freeze, "S. Brent Faulkner".freeze, "William Monk".freeze]
  s.date = "2013-11-14"
  s.description = "A simple wrapper for the standard ruby OpenSSL library to encrypt and decrypt strings".freeze
  s.email = ["shuber@huberry.com".freeze, "sbfaulkner@gmail.com".freeze, "billy.monk@gmail.com".freeze]
  s.homepage = "http://github.com/attr-encrypted/encryptor".freeze
  s.rubygems_version = "2.7.2".freeze
  s.summary = "A simple wrapper for the standard ruby OpenSSL library".freeze

  s.installed_by_version = "2.7.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, ["= 0.9.2.2"])
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_development_dependency(%q<simplecov-rcov>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rake>.freeze, ["= 0.9.2.2"])
      s.add_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_dependency(%q<simplecov-rcov>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>.freeze, ["= 0.9.2.2"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<simplecov-rcov>.freeze, [">= 0"])
  end
end
