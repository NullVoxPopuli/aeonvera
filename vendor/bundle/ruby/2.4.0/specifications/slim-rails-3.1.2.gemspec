# -*- encoding: utf-8 -*-
# stub: slim-rails 3.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "slim-rails".freeze
  s.version = "3.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Leonardo Almeida".freeze]
  s.date = "2017-03-03"
  s.description = "Provides the generator settings required for Rails 3+ to use Slim".freeze
  s.email = ["lalmeida08@gmail.com".freeze]
  s.homepage = "https://github.com/slim-template/slim-rails".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "2.7.2".freeze
  s.summary = "Slim templates generator for Rails 3+".freeze

  s.installed_by_version = "2.7.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionpack>.freeze, [">= 3.1"])
      s.add_runtime_dependency(%q<railties>.freeze, [">= 3.1"])
      s.add_runtime_dependency(%q<slim>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<sprockets-rails>.freeze, [">= 0"])
      s.add_development_dependency(%q<rocco>.freeze, [">= 0"])
      s.add_development_dependency(%q<redcarpet>.freeze, [">= 0"])
      s.add_development_dependency(%q<awesome_print>.freeze, [">= 0"])
      s.add_development_dependency(%q<actionmailer>.freeze, [">= 3.1"])
      s.add_development_dependency(%q<appraisal>.freeze, [">= 0"])
    else
      s.add_dependency(%q<actionpack>.freeze, [">= 3.1"])
      s.add_dependency(%q<railties>.freeze, [">= 3.1"])
      s.add_dependency(%q<slim>.freeze, ["~> 3.0"])
      s.add_dependency(%q<sprockets-rails>.freeze, [">= 0"])
      s.add_dependency(%q<rocco>.freeze, [">= 0"])
      s.add_dependency(%q<redcarpet>.freeze, [">= 0"])
      s.add_dependency(%q<awesome_print>.freeze, [">= 0"])
      s.add_dependency(%q<actionmailer>.freeze, [">= 3.1"])
      s.add_dependency(%q<appraisal>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<actionpack>.freeze, [">= 3.1"])
    s.add_dependency(%q<railties>.freeze, [">= 3.1"])
    s.add_dependency(%q<slim>.freeze, ["~> 3.0"])
    s.add_dependency(%q<sprockets-rails>.freeze, [">= 0"])
    s.add_dependency(%q<rocco>.freeze, [">= 0"])
    s.add_dependency(%q<redcarpet>.freeze, [">= 0"])
    s.add_dependency(%q<awesome_print>.freeze, [">= 0"])
    s.add_dependency(%q<actionmailer>.freeze, [">= 3.1"])
    s.add_dependency(%q<appraisal>.freeze, [">= 0"])
  end
end
