# -*- encoding: utf-8 -*-
# stub: aws-sdk 2.10.30 ruby lib

Gem::Specification.new do |s|
  s.name = "aws-sdk".freeze
  s.version = "2.10.30"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Amazon Web Services".freeze]
  s.date = "2017-08-21"
  s.description = "The official AWS SDK for Ruby. Provides both resource oriented interfaces and API clients for AWS services.".freeze
  s.email = ["trevrowe@amazon.com".freeze]
  s.homepage = "http://github.com/aws/aws-sdk-ruby".freeze
  s.licenses = ["Apache 2.0".freeze]
  s.rubygems_version = "2.7.4".freeze
  s.summary = "AWS SDK for Ruby".freeze

  s.installed_by_version = "2.7.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<aws-sdk-resources>.freeze, ["= 2.10.30"])
    else
      s.add_dependency(%q<aws-sdk-resources>.freeze, ["= 2.10.30"])
    end
  else
    s.add_dependency(%q<aws-sdk-resources>.freeze, ["= 2.10.30"])
  end
end
