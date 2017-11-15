# -*- encoding: utf-8 -*-
# stub: paranoia 2.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "paranoia".freeze
  s.version = "2.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["radarlistener@gmail.com".freeze]
  s.date = "2017-04-27"
  s.description = "    Paranoia is a re-implementation of acts_as_paranoid for Rails 3, 4, and 5,\n    using much, much, much less code. You would use either plugin / gem if you\n    wished that when you called destroy on an Active Record object that it\n    didn't actually destroy it, but just \"hid\" the record. Paranoia does this\n    by setting a deleted_at field to the current time when you destroy a record,\n    and hides it by scoping all queries on your model to only include records\n    which do not have a deleted_at field.\n".freeze
  s.email = ["ben@benmorgan.io".freeze, "john.hawthorn@gmail.com".freeze]
  s.homepage = "https://github.com/rubysherpas/paranoia".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0".freeze)
  s.rubygems_version = "2.7.2".freeze
  s.summary = "Paranoia is a re-implementation of acts_as_paranoid for Rails 3, 4, and 5, using much, much, much less code.".freeze

  s.installed_by_version = "2.7.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>.freeze, ["< 5.2", ">= 4.0"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 1.0.0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<activerecord>.freeze, ["< 5.2", ">= 4.0"])
      s.add_dependency(%q<bundler>.freeze, [">= 1.0.0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>.freeze, ["< 5.2", ">= 4.0"])
    s.add_dependency(%q<bundler>.freeze, [">= 1.0.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
