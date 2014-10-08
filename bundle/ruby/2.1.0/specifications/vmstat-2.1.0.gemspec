# -*- encoding: utf-8 -*-
# stub: vmstat 2.1.0 ruby lib
# stub: ext/vmstat/extconf.rb

Gem::Specification.new do |s|
  s.name = "vmstat"
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Vincent Landgraf"]
  s.date = "2013-12-05"
  s.description = "\n    A focused and fast library to gather memory, \n    cpu, network, load avg and disk information\n  "
  s.email = ["vilandgr@googlemail.com"]
  s.extensions = ["ext/vmstat/extconf.rb"]
  s.files = ["ext/vmstat/extconf.rb"]
  s.homepage = "http://threez.github.com/ruby-vmstat/"
  s.rubygems_version = "2.2.2"
  s.summary = "A focused and fast library to gather system information"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rake-compiler>, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0"])
      s.add_development_dependency(%q<timecop>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rake-compiler>, [">= 0"])
      s.add_dependency(%q<guard-rspec>, [">= 0"])
      s.add_dependency(%q<timecop>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rake-compiler>, [">= 0"])
    s.add_dependency(%q<guard-rspec>, [">= 0"])
    s.add_dependency(%q<timecop>, [">= 0"])
  end
end
