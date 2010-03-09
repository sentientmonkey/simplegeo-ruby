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
    simple = Simplegeo.new(@test_keys['key'], @test_keys['secret'])
    result = simple.nearby_address(47.607089,-122.332034)
    result.should be_a_kind_of(Hash)
    result['properties'].should_not be_nil
    result['properties']['place_name'].should eql('Seattle')
    result['properties']['state_name'].should eql('Washington')
    result['properties']['street'].should eql('5th Ave')
    result['properties']['postal_code'].should eql('98104')
    result['properties']['county_name'].should eql('King')
    result['properties']['country'].should eql('US')
  end

  it "should be able to find user stats" do
    simple = Simplegeo.new(@test_keys['key'], @test_keys['secret'], 'com.simplegeo.us.zip')
    result = simple.user_stats
    result.should be_a_kind_of(Hash)
    result['requests'].should_not be_nil
    result['requests']['nearby'].should_not be_nil
  end

  it "should be able to put record" do
    simple = Simplegeo.new(@test_keys['key'], @test_keys['secret'], 'com.sentientmonkey.test')
    result = simple.records.put(1, {:lat => 47.607089, :lon => -122.332034, :test => 'one'})
    result = simple.records.get(1)
    #TODO assertions
  end

  it "should be able to delete record" do
    simple = Simplegeo.new(@test_keys['key'], @test_keys['secret'], 'com.sentientmonkey.test')
    result = simple.records.put(2, {:lat => 47.607089, :lon => -122.332034, :test => 'two'})
    result = simple.records.delete(2)
    result = simple.records.get(2)
    #TODO assertions
  end

  it "should be able to find layer stats" do
    simple = Simplegeo.new(@test_keys['key'], @test_keys['secret'], 'com.sentientmonkey.test')
    result = simple.layer_stats
    result.should be_a_kind_of(Hash)
    result['requests'].should_not be_nil
  end

  it "should raise NotFound exception on invalid record" do
    simple = Simplegeo.new(@test_keys['key'], @test_keys['secret'], 'com.simplegeo.us.zip')
    lambda{ simple.records.get(1) }.should raise_exception(Simplegeo::NotFound)
  end

  it "should raise NotAuthorized exception on invalid keys" do
    simple = Simplegeo.new('bad key', 'bad secret', 'com.simplegeo.us.zip')
    lambda{ simple.records.get(98122) }.should raise_exception(Simplegeo::NotAuthorized)
  end

end
