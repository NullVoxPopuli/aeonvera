# -*- encoding: utf-8 -*-
# stub: render_anywhere 0.0.12 ruby lib

Gem::Specification.new do |s|
  s.name = "render_anywhere".freeze
  s.version = "0.0.12"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Luke Melia".freeze]
  s.date = "2015-08-30"
  s.description = "Out of the box, Rails will render templates in a controller context only. This gem allows for calling \"render\" from anywhere: models, background jobs, rake tasks, you name it.".freeze
  s.email = ["luke@lukemelia.com".freeze]
  s.homepage = "".freeze
  s.licenses = ["MIT".freeze]
  s.rubyforge_project = "render_anywhere".freeze
  s.rubygems_version = "2.7.4".freeze
  s.summary = "Render Rails templates to a string from anywhere.".freeze

  s.installed_by_version = "2.7.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>.freeze, [">= 3.0.7"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<appraisal>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rails>.freeze, [">= 3.0.7"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<appraisal>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>.freeze, [">= 3.0.7"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<appraisal>.freeze, [">= 0"])
  end
end
