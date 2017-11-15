# -*- encoding: utf-8 -*-
# stub: dante 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "dante".freeze
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Nathan Esquenazi".freeze]
  s.date = "2013-12-04"
  s.description = "Turn any process into a demon.".freeze
  s.email = ["nesquena@gmail.com".freeze]
  s.homepage = "https://github.com/bazaarlabs/dante".freeze
  s.rubyforge_project = "dante".freeze
  s.rubygems_version = "2.7.2".freeze
  s.summary = "Turn any process into a demon".freeze

  s.installed_by_version = "2.7.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
      s.add_development_dependency(%q<mocha>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<minitest>.freeze, [">= 0"])
      s.add_dependency(%q<mocha>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, [">= 0"])
    s.add_dependency(%q<mocha>.freeze, [">= 0"])
  end
end
