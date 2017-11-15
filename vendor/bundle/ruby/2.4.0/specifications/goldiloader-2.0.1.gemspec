# -*- encoding: utf-8 -*-
# stub: goldiloader 2.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "goldiloader".freeze
  s.version = "2.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Joel Turkel".freeze]
  s.date = "2017-05-05"
  s.description = "Automatically eager loads Rails associations as associations are traversed".freeze
  s.email = ["jturkel@salsify.com".freeze]
  s.homepage = "https://github.com/salsify/goldiloader".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.1".freeze)
  s.rubygems_version = "2.7.2".freeze
  s.summary = "Automatic Rails association eager loading".freeze

  s.installed_by_version = "2.7.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>.freeze, ["< 5.2", ">= 4.2"])
      s.add_runtime_dependency(%q<activesupport>.freeze, ["< 5.2", ">= 4.2"])
      s.add_development_dependency(%q<coveralls>.freeze, [">= 0"])
      s.add_development_dependency(%q<database_cleaner>.freeze, [">= 1.2"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3"])
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_development_dependency(%q<mime-types>.freeze, [">= 0"])
      s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
    else
      s.add_dependency(%q<activerecord>.freeze, ["< 5.2", ">= 4.2"])
      s.add_dependency(%q<activesupport>.freeze, ["< 5.2", ">= 4.2"])
      s.add_dependency(%q<coveralls>.freeze, [">= 0"])
      s.add_dependency(%q<database_cleaner>.freeze, [">= 1.2"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3"])
      s.add_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_dependency(%q<mime-types>.freeze, [">= 0"])
      s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>.freeze, ["< 5.2", ">= 4.2"])
    s.add_dependency(%q<activesupport>.freeze, ["< 5.2", ">= 4.2"])
    s.add_dependency(%q<coveralls>.freeze, [">= 0"])
    s.add_dependency(%q<database_cleaner>.freeze, [">= 1.2"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<mime-types>.freeze, [">= 0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
  end
end
