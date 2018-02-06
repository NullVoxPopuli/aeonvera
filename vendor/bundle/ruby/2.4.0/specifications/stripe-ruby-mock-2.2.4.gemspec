# -*- encoding: utf-8 -*-
# stub: stripe-ruby-mock 2.2.4 ruby lib

Gem::Specification.new do |s|
  s.name = "stripe-ruby-mock".freeze
  s.version = "2.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Gilbert".freeze]
  s.date = "2016-05-06"
  s.description = "A drop-in library to test stripe without hitting their servers".freeze
  s.email = "gilbertbgarza@gmail.com".freeze
  s.executables = ["stripe-mock-server".freeze]
  s.files = ["bin/stripe-mock-server".freeze]
  s.homepage = "https://github.com/rebelidealist/stripe-ruby-mock".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.4".freeze
  s.summary = "TDD with stripe".freeze

  s.installed_by_version = "2.7.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<stripe>.freeze, ["< 1.42", ">= 1.31.0"])
      s.add_runtime_dependency(%q<jimson-temp>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<dante>.freeze, [">= 0.2.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.1.0"])
      s.add_development_dependency(%q<rubygems-tasks>.freeze, ["~> 0.2"])
      s.add_development_dependency(%q<thin>.freeze, [">= 0"])
    else
      s.add_dependency(%q<stripe>.freeze, ["< 1.42", ">= 1.31.0"])
      s.add_dependency(%q<jimson-temp>.freeze, [">= 0"])
      s.add_dependency(%q<dante>.freeze, [">= 0.2.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.1.0"])
      s.add_dependency(%q<rubygems-tasks>.freeze, ["~> 0.2"])
      s.add_dependency(%q<thin>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<stripe>.freeze, ["< 1.42", ">= 1.31.0"])
    s.add_dependency(%q<jimson-temp>.freeze, [">= 0"])
    s.add_dependency(%q<dante>.freeze, [">= 0.2.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.1.0"])
    s.add_dependency(%q<rubygems-tasks>.freeze, ["~> 0.2"])
    s.add_dependency(%q<thin>.freeze, [">= 0"])
  end
end
