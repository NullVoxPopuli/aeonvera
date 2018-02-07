# -*- encoding: utf-8 -*-
# stub: roadie 2.4.3 ruby lib

Gem::Specification.new do |s|
  s.name = "roadie".freeze
  s.version = "2.4.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Magnus Bergmark".freeze]
  s.date = "2013-12-02"
  s.description = "Roadie tries to make sending HTML emails a little less painful in Rails 3 by inlining stylesheets and rewrite relative URLs for you.".freeze
  s.email = ["magnus.bergmark@gmail.com".freeze]
  s.extra_rdoc_files = ["README.md".freeze, "Changelog.md".freeze]
  s.files = ["Changelog.md".freeze, "README.md".freeze]
  s.homepage = "http://github.com/Mange/roadie".freeze
  s.rubygems_version = "2.7.4".freeze
  s.summary = "Making HTML emails comfortable for the Rails rockstars".freeze

  s.installed_by_version = "2.7.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>.freeze, ["> 1.5.0"])
      s.add_runtime_dependency(%q<css_parser>.freeze, ["~> 1.3.4"])
      s.add_runtime_dependency(%q<actionmailer>.freeze, ["< 5.0.0", "> 3.0.0"])
      s.add_runtime_dependency(%q<sprockets>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rails>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>.freeze, [">= 0"])
      s.add_development_dependency(%q<appraisal>.freeze, [">= 0"])
    else
      s.add_dependency(%q<nokogiri>.freeze, ["> 1.5.0"])
      s.add_dependency(%q<css_parser>.freeze, ["~> 1.3.4"])
      s.add_dependency(%q<actionmailer>.freeze, ["< 5.0.0", "> 3.0.0"])
      s.add_dependency(%q<sprockets>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rails>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
      s.add_dependency(%q<appraisal>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<nokogiri>.freeze, ["> 1.5.0"])
    s.add_dependency(%q<css_parser>.freeze, ["~> 1.3.4"])
    s.add_dependency(%q<actionmailer>.freeze, ["< 5.0.0", "> 3.0.0"])
    s.add_dependency(%q<sprockets>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rails>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
    s.add_dependency(%q<appraisal>.freeze, [">= 0"])
  end
end
