# -*- encoding: utf-8 -*-
# stub: arbre 1.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "arbre".freeze
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Greg Bell".freeze]
  s.date = "2016-07-01"
  s.description = "An Object Oriented DOM Tree in Ruby".freeze
  s.email = ["gregdbell@gmail.com".freeze]
  s.homepage = "".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.2".freeze
  s.summary = "An Object Oriented DOM Tree in Ruby".freeze

  s.installed_by_version = "2.7.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>.freeze, [">= 3.0.0"])
    else
      s.add_dependency(%q<activesupport>.freeze, [">= 3.0.0"])
    end
  else
    s.add_dependency(%q<activesupport>.freeze, [">= 3.0.0"])
  end
end
