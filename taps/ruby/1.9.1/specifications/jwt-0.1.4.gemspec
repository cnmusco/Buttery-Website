# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jwt}
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeff Lindsay"]
  s.date = %q{2011-11-11}
  s.description = %q{JSON Web Token implementation in Ruby}
  s.email = %q{jeff.lindsay@twilio.com}
  s.homepage = %q{http://github.com/progrium/ruby-jwt}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{jwt}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{JSON Web Token implementation in Ruby}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 1.2.4"])
    else
      s.add_dependency(%q<json>, [">= 1.2.4"])
    end
  else
    s.add_dependency(%q<json>, [">= 1.2.4"])
  end
end
