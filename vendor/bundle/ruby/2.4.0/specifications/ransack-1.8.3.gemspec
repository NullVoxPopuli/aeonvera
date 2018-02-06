# -*- encoding: utf-8 -*-
# stub: ransack 1.8.3 ruby lib

Gem::Specification.new do |s|
  s.name = "ransack".freeze
  s.version = "1.8.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ernie Miller".freeze, "Ryan Bigg".freeze, "Jon Atack".freeze]
  s.date = "2017-06-15"
  s.description = "Ransack is the successor to the MetaSearch gem. It improves and expands upon MetaSearch's functionality, but does not have a 100%-compatible API.".freeze
  s.email = ["ernie@erniemiller.org".freeze, "radarlistener@gmail.com".freeze, "jonnyatack@gmail.com".freeze]
  s.homepage = "https://github.com/activerecord-hackery/ransack".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9".freeze)
  s.rubyforge_project = "ransack".freeze
  s.rubygems_version = "2.7.4".freeze
  s.summary = "Object-based searching for Active Record and Mongoid (currently).".freeze

  s.installed_by_version = "2.7.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionpack>.freeze, [">= 3.0"])
      s.add_runtime_dependency(%q<activerecord>.freeze, [">= 3.0"])
      s.add_runtime_dependency(%q<activesupport>.freeze, [">= 3.0"])
      s.add_runtime_dependency(%q<i18n>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<polyamorous>.freeze, ["~> 1.3"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3"])
      s.add_development_dependency(%q<machinist>.freeze, ["~> 1.0.6"])
      s.add_development_dependency(%q<faker>.freeze, ["~> 0.9.5"])
      s.add_development_dependency(%q<sqlite3>.freeze, ["~> 1.3.3"])
      s.add_development_dependency(%q<pg>.freeze, [">= 0"])
      s.add_development_dependency(%q<mysql2>.freeze, ["= 0.3.20"])
      s.add_development_dependency(%q<pry>.freeze, ["= 0.10"])
    else
      s.add_dependency(%q<actionpack>.freeze, [">= 3.0"])
      s.add_dependency(%q<activerecord>.freeze, [">= 3.0"])
      s.add_dependency(%q<activesupport>.freeze, [">= 3.0"])
      s.add_dependency(%q<i18n>.freeze, [">= 0"])
      s.add_dependency(%q<polyamorous>.freeze, ["~> 1.3"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3"])
      s.add_dependency(%q<machinist>.freeze, ["~> 1.0.6"])
      s.add_dependency(%q<faker>.freeze, ["~> 0.9.5"])
      s.add_dependency(%q<sqlite3>.freeze, ["~> 1.3.3"])
      s.add_dependency(%q<pg>.freeze, [">= 0"])
      s.add_dependency(%q<mysql2>.freeze, ["= 0.3.20"])
      s.add_dependency(%q<pry>.freeze, ["= 0.10"])
    end
  else
    s.add_dependency(%q<actionpack>.freeze, [">= 3.0"])
    s.add_dependency(%q<activerecord>.freeze, [">= 3.0"])
    s.add_dependency(%q<activesupport>.freeze, [">= 3.0"])
    s.add_dependency(%q<i18n>.freeze, [">= 0"])
    s.add_dependency(%q<polyamorous>.freeze, ["~> 1.3"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3"])
    s.add_dependency(%q<machinist>.freeze, ["~> 1.0.6"])
    s.add_dependency(%q<faker>.freeze, ["~> 0.9.5"])
    s.add_dependency(%q<sqlite3>.freeze, ["~> 1.3.3"])
    s.add_dependency(%q<pg>.freeze, [">= 0"])
    s.add_dependency(%q<mysql2>.freeze, ["= 0.3.20"])
    s.add_dependency(%q<pry>.freeze, ["= 0.10"])
  end
end
