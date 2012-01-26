# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{twilio-ruby}
  s.version = "3.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andrew Benton"]
  s.date = %q{2011-10-13}
  s.description = %q{A simple library for communicating with the Twilio REST API, building TwiML, and generating Twilio Client Capability Tokens}
  s.email = %q{andrew@twilio.com}
  s.files = ["test/twilio_spec.rb"]
  s.homepage = %q{http://github.com/twilio/twilio-ruby}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{A simple library for communicating with the Twilio REST API, building TwiML, and generating Twilio Client Capability Tokens}
  s.test_files = ["test/twilio_spec.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<multi_json>, [">= 1.0.3"])
      s.add_runtime_dependency(%q<builder>, [">= 2.1.2"])
      s.add_runtime_dependency(%q<jwt>, [">= 0.1.2"])
      s.add_development_dependency(%q<rake>, ["~> 0.9.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_development_dependency(%q<fakeweb>, ["~> 1.3.0"])
      s.add_development_dependency(%q<rack>, ["~> 1.3.0"])
    else
      s.add_dependency(%q<multi_json>, [">= 1.0.3"])
      s.add_dependency(%q<builder>, [">= 2.1.2"])
      s.add_dependency(%q<jwt>, [">= 0.1.2"])
      s.add_dependency(%q<rake>, ["~> 0.9.0"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_dependency(%q<fakeweb>, ["~> 1.3.0"])
      s.add_dependency(%q<rack>, ["~> 1.3.0"])
    end
  else
    s.add_dependency(%q<multi_json>, [">= 1.0.3"])
    s.add_dependency(%q<builder>, [">= 2.1.2"])
    s.add_dependency(%q<jwt>, [">= 0.1.2"])
    s.add_dependency(%q<rake>, ["~> 0.9.0"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    s.add_dependency(%q<fakeweb>, ["~> 1.3.0"])
    s.add_dependency(%q<rack>, ["~> 1.3.0"])
  end
end
