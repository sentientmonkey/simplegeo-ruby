require 'rubygems'

gem 'crack', '~> 0.1.7'
require 'crack'

gem 'oauth', '~> 0.3.6'
require 'oauth'

gem 'json', '>= 1.2.2'
require 'json'

require 'forwardable'
require 'uri'

# This is a client for accessing Simplegeo's REST APIs
# for full documentation see:
# http://help.simplegeo.com/faqs/api-documentation/endpoints

class Simplegeo
  BASE_URI = 'http://api.simplegeo.com'
  VER = '0.1'
  attr_accessor :layer
  attr_reader :access_token

  extend Forwardable
  def_delegators :access_token, :get, :post, :put, :delete

  class NotAuthorized < StandardError; end
  class NotFound < StandardError; end
  class InternalError < StandardError; end

  # initialize a new client with a acess key, secret key, and a default layer
  def initialize(key, secret, layer = nil)
    @access_token = self.class.get_access_token(key, secret)
    @layer = layer
  end
 
  # find nearby objects given a lat & lng
  # by default, only searches the the current layer
  def nearby(lat, lng, options = {})
    options[:layers] ||= [self.layer]
    perform_get("/nearby/#{lat},#{lng}.json", :query => options)
  end

  # reverse geocodes a lat & lng
  def nearby_address(lat, lng, options = {})
    perform_get("/nearby/address/#{lat},#{lng}.json", :query => options)
  end

  def user_stats
    perform_get("/stats.json")
  end

  def layer_stats
    perform_get("/stats/#{layer}.json")
  end

  class Records
    def initialize(simplegeo) #:nodoc:
      @simplegeo = simplegeo
    end

    # get a record by id
    def get(id)
      @simplegeo.records_dispatch(:get, id)
    end

    # put a record by id
    # data should be a hash with at least lat & lon keys, as well as extra data
    def put(id, data)
      @simplegeo.records_dispatch(:put, id, data)
    end

    # delete a record by id
    def delete(id)
      @simplegeo.records_dispatch(:delete, id)
    end

    # get the history of a record by id
    def history(id)
      @simplegeo.records_dispatch(:get_history, id)
    end
  end

  # used to access record APIs
  # i.e. client.records.get(1)
  def records
    Records.new(self)
  end

  def records_dispatch(operation, id, body = nil) #:nodoc:
    case operation
    when :get_history
      perform(:get, "/records/#{layer}/#{id}/history.json")
    when :put
      perform(:put, "/records/#{layer}/#{id}.json", :body => build_feature(id, body))
    else
      perform(operation, "/records/#{layer}/#{id}.json")
    end
  end

  protected

  def self.get_access_token(key, secret)
    consumer = OAuth::Consumer.new(key,secret, :site => BASE_URI)
    OAuth::AccessToken.new(consumer)
  end

  def perform(operation, path, options = {})
    case operation
    when :put, :post
      handle_response(self.send(operation, build_uri(path, options), options[:body].to_json))
    else
      handle_response(self.send(operation, build_uri(path, options)))
    end
  end

  def perform_get(path, options = {})
    perform(:get, path, options)
  end

  def perform_delete(path, options = {})
    perform(:delete, path, options)
  end

  def perform_put(path, options = {})
    perform(:put, path, options)
  end

  def perform_post(path, options = {})
    perform(:post, path, options)
  end

  def build_uri(path, options = {})
    uri = URI.parse("/#{VER}#{path}")
    uri.query = build_query(options[:query])
    uri.to_s 
  end

  def build_query(query)
    if query && query != {}
      query.map do |k,v|
        [k.to_s,v.to_s].join('=')
      end.join('&')
    end
  end

  def build_feature(id, body)
    {:type => 'Feature', 
     :id => id,
     :created => body[:created],
     :geometry => { :type => 'Point',
                    :coordinates => [body[:lon], body[:lat]]},
     :properties => body.reject{|k,v| [:created, :lat, :lon].include?(k) }}
  end

  def handle_response(response)
    raise_errors(response)
    parse(response)
  end

  def raise_errors(response)
    case response.code.to_i
      when 401
        raise NotAuthorized.new "(#{response.code}): #{response.message}"
      when 404
        raise NotFound.new "(#{response.code}): #{response.message}"
      when 500
        raise InternalError.new "(#{response.code}): #{response.message}"
    end
  end
 
  def parse(response)
    Crack::JSON.parse(response.body)
  end

end
