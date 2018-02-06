# -*- encoding: utf-8 -*-
# stub: delorean 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "delorean".freeze
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Luismi Cavall\u00C3\u00A9".freeze, "Sergio Gil".freeze]
  s.date = "2012-12-06"
  s.email = "ballsbreaking@bebanjo.com".freeze
  s.extra_rdoc_files = ["README.md".freeze]
  s.files = ["README.md".freeze]
  s.homepage = "http://github.com/bebanjo/delorean".freeze
  s.rubygems_version = "2.7.4".freeze
  s.summary = "Delorean lets you travel in time with Ruby by mocking Time.now".freeze

  s.installed_by_version = "2.7.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<chronic>.freeze, [">= 0"])
    else
      s.add_dependency(%q<chronic>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<chronic>.freeze, [">= 0"])
  end
end
