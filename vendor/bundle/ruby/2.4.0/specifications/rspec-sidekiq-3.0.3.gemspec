# -*- encoding: utf-8 -*-
# stub: rspec-sidekiq 3.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "rspec-sidekiq".freeze
  s.version = "3.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Phil Ostler".freeze]
  s.date = "2017-06-23"
  s.description = "Simple testing of Sidekiq jobs via a collection of matchers and helpers".freeze
  s.email = "github@philostler.com".freeze
  s.homepage = "http://github.com/philostler/rspec-sidekiq".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.2".freeze
  s.summary = "RSpec for Sidekiq".freeze

  s.installed_by_version = "2.7.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rspec-core>.freeze, [">= 3.0.0", "~> 3.0"])
      s.add_runtime_dependency(%q<sidekiq>.freeze, [">= 2.4.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<coveralls>.freeze, [">= 0.8.0", "~> 0.8"])
      s.add_development_dependency(%q<fuubar>.freeze, [">= 2.0.0", "~> 2.0"])
      s.add_development_dependency(%q<activejob>.freeze, [">= 4.0.0", "~> 4.2"])
      s.add_development_dependency(%q<actionmailer>.freeze, [">= 4.0.0", "~> 4.2"])
      s.add_development_dependency(%q<activerecord>.freeze, [">= 4.0.0", "~> 4.2"])
    else
      s.add_dependency(%q<rspec-core>.freeze, [">= 3.0.0", "~> 3.0"])
      s.add_dependency(%q<sidekiq>.freeze, [">= 2.4.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_dependency(%q<coveralls>.freeze, [">= 0.8.0", "~> 0.8"])
      s.add_dependency(%q<fuubar>.freeze, [">= 2.0.0", "~> 2.0"])
      s.add_dependency(%q<activejob>.freeze, [">= 4.0.0", "~> 4.2"])
      s.add_dependency(%q<actionmailer>.freeze, [">= 4.0.0", "~> 4.2"])
      s.add_dependency(%q<activerecord>.freeze, [">= 4.0.0", "~> 4.2"])
    end
  else
    s.add_dependency(%q<rspec-core>.freeze, [">= 3.0.0", "~> 3.0"])
    s.add_dependency(%q<sidekiq>.freeze, [">= 2.4.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<coveralls>.freeze, [">= 0.8.0", "~> 0.8"])
    s.add_dependency(%q<fuubar>.freeze, [">= 2.0.0", "~> 2.0"])
    s.add_dependency(%q<activejob>.freeze, [">= 4.0.0", "~> 4.2"])
    s.add_dependency(%q<actionmailer>.freeze, [">= 4.0.0", "~> 4.2"])
    s.add_dependency(%q<activerecord>.freeze, [">= 4.0.0", "~> 4.2"])
  end
end
