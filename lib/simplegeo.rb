require 'rubygems'
require 'httparty'
require 'oauth'

class Simplegeo
  include HTTParty
  base_uri 'http://api.simplegeo.com/0.1/'
  debug_output $stderr

  attr_accessor :layer

  def self.get_access_token(key, secret)
    consumer = OAuth::Consumer.new(key,secret, :site => base_uri)
    OAuth::AccessToken.new(consumer)
  end

  def initialize(layer)
    @layer = layer
  end
 
  def nearby(lat, lng)
    self.class.get("/nearby/#{lat},#{lng}.json")
  end

  def nearby_address(lat, lng)
    self.class.get("/nearby/address/#{lat},#{lng}.json")
  end

  class Records
    def initialize(simplegeo)
      @simplegeo = simplegeo
    end

    def get(id)
      @simplegeo.records_dispatch(:get, id)
    end

    def put(id, data)
      @simplegeo.records_dispatch(:put, id, data)
    end

    def delete(id)
      @simplegeo.records_dispatch(:delete, id)
    end
  end

  def records
    Records.new(self)
  end

  def records_dispatch(operation, id, data = nil)
    self.class.send(operation, "/records/#{layer}/#{id}.json", :body => data)
  end
end