# -*- encoding: utf-8 -*-
# stub: reform 2.2.4 ruby lib

Gem::Specification.new do |s|
  s.name = "reform".freeze
  s.version = "2.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Nick Sutterer".freeze, "Garrett Heinlen".freeze]
  s.date = "2017-01-31"
  s.description = "Form object decoupled from models.".freeze
  s.email = ["apotonick@gmail.com".freeze, "heinleng@gmail.com".freeze]
  s.homepage = "https://github.com/apotonick/reform".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.2".freeze
  s.summary = "Form object decoupled from models with validation, population and presentation.".freeze

  s.installed_by_version = "2.7.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<disposable>.freeze, [">= 0.4.1"])
      s.add_runtime_dependency(%q<representable>.freeze, ["< 3.1.0", ">= 2.4.0"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
      s.add_development_dependency(%q<dry-types>.freeze, [">= 0"])
      s.add_development_dependency(%q<multi_json>.freeze, [">= 0"])
      s.add_development_dependency(%q<dry-validation>.freeze, [">= 0.10.0"])
    else
      s.add_dependency(%q<disposable>.freeze, [">= 0.4.1"])
      s.add_dependency(%q<representable>.freeze, ["< 3.1.0", ">= 2.4.0"])
      s.add_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<minitest>.freeze, [">= 0"])
      s.add_dependency(%q<dry-types>.freeze, [">= 0"])
      s.add_dependency(%q<multi_json>.freeze, [">= 0"])
      s.add_dependency(%q<dry-validation>.freeze, [">= 0.10.0"])
    end
  else
    s.add_dependency(%q<disposable>.freeze, [">= 0.4.1"])
    s.add_dependency(%q<representable>.freeze, ["< 3.1.0", ">= 2.4.0"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, [">= 0"])
    s.add_dependency(%q<dry-types>.freeze, [">= 0"])
    s.add_dependency(%q<multi_json>.freeze, [">= 0"])
    s.add_dependency(%q<dry-validation>.freeze, [">= 0.10.0"])
  end
end
