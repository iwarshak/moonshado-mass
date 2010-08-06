# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{moonshado-mass}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ian Warshak"]
  s.date = %q{2010-08-06}
  s.description = %q{Send bulk SMS messages through Moonshado}
  s.email = %q{iwarshak@stripey.net}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/moonshado-mass.rb",
     "lib/moonshadosms/sender.rb",
     "moonshado-mass.gemspec",
     "test/helper.rb",
     "test/test_moonshado-mass.rb"
  ]
  s.homepage = %q{http://github.com/iwarshak/moonshado-mass}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Send bulk SMS messages through Moonshado}
  s.test_files = [
    "test/helper.rb",
     "test/test_moonshado-mass.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_runtime_dependency(%q<rest-client>, [">= 1.6.0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_dependency(%q<rest-client>, [">= 1.6.0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    s.add_dependency(%q<rest-client>, [">= 1.6.0"])
  end
end

