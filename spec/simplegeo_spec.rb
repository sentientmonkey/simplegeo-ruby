require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

KEY = 'your key'
SECRET = 'your secret'

describe "Simplegeo" do
  it "should be able to get an access token" do
    access_token = Simplegeo.get_access_token(KEY, SECRET)
    puts access_token.get("/records/com.simplegeo.global.flickr/4407858938.json")
  end
end
