# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{simplegeo}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Scott Windsor"]
  s.date = %q{2010-03-08}
  s.description = %q{a simplegeo client written in ruby.  see http://help.simplegeo.com/faqs/api-documentation/endpoints for more info.}
  s.email = %q{swindsor@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/simplegeo.rb",
     "simplegeo.gemspec",
     "spec/simplegeo_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/test_keys.yml"
  ]
  s.homepage = %q{http://github.com/sentientmonkey/simplegeo-ruby}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{a simplegeo client written in ruby}
  s.test_files = [
    "spec/simplegeo_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_runtime_dependency(%q<oauth>, [">= 0.3.6"])
      s.add_runtime_dependency(%q<crack>, [">= 0.1.7"])
      s.add_runtime_dependency(%q<json>, [">= 1.2.2"])
    else
      s.add_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_dependency(%q<oauth>, [">= 0.3.6"])
      s.add_dependency(%q<crack>, [">= 0.1.7"])
      s.add_dependency(%q<json>, [">= 1.2.2"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.3.0"])
    s.add_dependency(%q<oauth>, [">= 0.3.6"])
    s.add_dependency(%q<crack>, [">= 0.1.7"])
    s.add_dependency(%q<json>, [">= 1.2.2"])
  end
end

