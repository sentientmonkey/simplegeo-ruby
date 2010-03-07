require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Simplegeo" do
  it "should be able to get an access token" do
    access_token = Simplegeo.get_access_token(@test_keys['key'], @test_keys['secret'])
    result = access_token.get("/0.1/records/com.simplegeo.us.zip/98122.json")
    result.should be_a_kind_of(Net::HTTPOK)
  end

  it "should be able to find a record" do
    simple = Simplegeo.new(@test_keys['key'], @test_keys['secret'], 'com.simplegeo.us.zip')
    result = simple.records.get(98122)
    result.should be_a_kind_of(Hash)
    result['id'].should eql('98122')
  end

  it "should be able to find history for a record" do
    simple = Simplegeo.new(@test_keys['key'], @test_keys['secret'], 'com.simplegeo.us.zip')
    result = simple.records.history(98122)
    result.should be_a_kind_of(Hash)
  end

  it "should be able to find nearby" do
    simple = Simplegeo.new(@test_keys['key'], @test_keys['secret'], 'com.simplegeo.us.zip')
    result = simple.nearby(47.607089,-122.332034)
    result.should be_a_kind_of(Hash)
  end

  it "should be able to find nearby address" do
    simple = Simplegeo.new(@test_keys['key'], @test_keys['secret'], 'com.simplegeo.us.zip')
    result = simple.nearby(47.607089,-122.332034)
    result.should be_a_kind_of(Hash)
  end

end
