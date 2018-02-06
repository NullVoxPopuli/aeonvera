# -*- encoding: utf-8 -*-
# stub: jimson-temp 0.9.5 ruby lib

Gem::Specification.new do |s|
  s.name = "jimson-temp".freeze
  s.version = "0.9.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Chris Kite".freeze]
  s.date = "2013-06-09"
  s.extra_rdoc_files = ["README.md".freeze]
  s.files = ["README.md".freeze]
  s.homepage = "https://github.com/mindeavor/jimson.git".freeze
  s.rubygems_version = "2.7.4".freeze
  s.summary = "JSON-RPC 2.0 client and server".freeze

  s.installed_by_version = "2.7.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<blankslate>.freeze, [">= 3.1.2"])
      s.add_runtime_dependency(%q<rest-client>.freeze, ["~> 1.0"])
      s.add_runtime_dependency(%q<multi_json>.freeze, ["~> 1.0"])
      s.add_runtime_dependency(%q<rack>.freeze, ["~> 1.4"])
    else
      s.add_dependency(%q<blankslate>.freeze, [">= 3.1.2"])
      s.add_dependency(%q<rest-client>.freeze, ["~> 1.0"])
      s.add_dependency(%q<multi_json>.freeze, ["~> 1.0"])
      s.add_dependency(%q<rack>.freeze, ["~> 1.4"])
    end
  else
    s.add_dependency(%q<blankslate>.freeze, [">= 3.1.2"])
    s.add_dependency(%q<rest-client>.freeze, ["~> 1.0"])
    s.add_dependency(%q<multi_json>.freeze, ["~> 1.0"])
    s.add_dependency(%q<rack>.freeze, ["~> 1.4"])
  end
end
