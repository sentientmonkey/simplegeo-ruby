require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "simplegeo"
    gem.summary = %Q{a simplegeo client written in ruby}
    gem.description = %Q{a simplegeo client written in ruby}
    gem.email = "swindsor@gmail.com"
    gem.homepage = "http://github.com/sentientmonkey/simplegeo-ruby"
    gem.authors = ["Scott Windsor"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_dependency('oauth', '>= 0.3.6')
    gem.add_dependency('crack', '>= 0.1.7')
    gem.add_dependency('json', '>= 1.2.2')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "simplegeo #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
