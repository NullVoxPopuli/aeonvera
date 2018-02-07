# -*- encoding: utf-8 -*-
# stub: attr_encrypted 1.3.5 ruby lib

Gem::Specification.new do |s|
  s.name = "attr_encrypted".freeze
  s.version = "1.3.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sean Huber".freeze, "S. Brent Faulkner".freeze, "William Monk".freeze, "Stephen Aghaulor".freeze]
  s.date = "2016-01-12"
  s.description = "Generates attr_accessors that encrypt and decrypt attributes transparently".freeze
  s.email = ["shuber@huberry.com".freeze, "sbfaulkner@gmail.com".freeze, "billy.monk@gmail.com".freeze, "saghaulor@gmail.com".freeze]
  s.homepage = "http://github.com/attr-encrypted/attr_encrypted".freeze
  s.rdoc_options = ["--line-numbers".freeze, "--inline-source".freeze, "--main".freeze, "README.rdoc".freeze]
  s.rubygems_version = "2.7.4".freeze
  s.summary = "Encrypt and decrypt attributes".freeze

  s.installed_by_version = "2.7.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<encryptor>.freeze, ["~> 1.3.0"])
      s.add_development_dependency(%q<activerecord>.freeze, [">= 2.0.0"])
      s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
      s.add_development_dependency(%q<datamapper>.freeze, [">= 0"])
      s.add_development_dependency(%q<addressable>.freeze, ["= 2.3.7"])
      s.add_development_dependency(%q<mocha>.freeze, ["~> 1.0.0"])
      s.add_development_dependency(%q<sequel>.freeze, [">= 0"])
      s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
      s.add_development_dependency(%q<dm-sqlite-adapter>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, ["= 0.9.2.2"])
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_development_dependency(%q<simplecov-rcov>.freeze, [">= 0"])
    else
      s.add_dependency(%q<encryptor>.freeze, ["~> 1.3.0"])
      s.add_dependency(%q<activerecord>.freeze, [">= 2.0.0"])
      s.add_dependency(%q<minitest>.freeze, [">= 0"])
      s.add_dependency(%q<datamapper>.freeze, [">= 0"])
      s.add_dependency(%q<addressable>.freeze, ["= 2.3.7"])
      s.add_dependency(%q<mocha>.freeze, ["~> 1.0.0"])
      s.add_dependency(%q<sequel>.freeze, [">= 0"])
      s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
      s.add_dependency(%q<dm-sqlite-adapter>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, ["= 0.9.2.2"])
      s.add_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_dependency(%q<simplecov-rcov>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<encryptor>.freeze, ["~> 1.3.0"])
    s.add_dependency(%q<activerecord>.freeze, [">= 2.0.0"])
    s.add_dependency(%q<minitest>.freeze, [">= 0"])
    s.add_dependency(%q<datamapper>.freeze, [">= 0"])
    s.add_dependency(%q<addressable>.freeze, ["= 2.3.7"])
    s.add_dependency(%q<mocha>.freeze, ["~> 1.0.0"])
    s.add_dependency(%q<sequel>.freeze, [">= 0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_dependency(%q<dm-sqlite-adapter>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, ["= 0.9.2.2"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<simplecov-rcov>.freeze, [">= 0"])
  end
end
