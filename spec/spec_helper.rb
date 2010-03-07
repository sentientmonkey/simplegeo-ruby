$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'simplegeo'
require 'spec'
require 'spec/autorun'
require 'yaml'

Spec::Runner.configure do |config|
  config.before(:all) do
    @test_keys = YAML::load_file(File.join(File.dirname(__FILE__), "test_keys.yml"))
    if @test_keys['key'] == 'key' || @test_keys['secret'] == 'secret'
      raise 'test keys not set!  add your keys to test_keys.yml'
    end
  end
end
