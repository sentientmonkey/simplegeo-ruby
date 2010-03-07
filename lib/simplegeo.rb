require 'rubygems'
require 'crack'
require 'oauth'
require 'forwardable'

class Simplegeo
  BASE_URI = 'http://api.simplegeo.com'
  VER = '0.1'
  attr_accessor :layer
  attr_reader :access_token
  extend Forwardable

  def_delegators :access_token, :get, :post, :put, :delete

  def initialize(key, secret, layer = nil)
    @access_token = self.class.get_access_token(key, secret)
    @layer = layer
  end
 
  def nearby(lat, lng, options = {})
    options = {}
    options[:layers] ||= [self.layer]
    perform_get("/nearby/#{lat},#{lng}.json", :query => options)
  end

  def nearby_address(lat, lng)
    options = {}
    options[:layers] ||= [self.layer]
    perform_get("/nearby/address/#{lat},#{lng}.json", :query => options)
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

    def history(id)
      @simplegeo.records_dispatch(:get_history, id)
    end
  end

  def records
    Records.new(self)
  end

  def records_dispatch(operation, id, data = nil)
    case operation
    when :get_history
      perform(:get, "/records/#{layer}/#{id}/history.json")
    else
      perform(operation, "/records/#{layer}/#{id}.json", :data => data)
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
      handle_response(self.send(operation, options[:data], build_uri(path, options)))
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
        [k,v].join('=')
      end.join('&')
    end
  end

  def handle_response(response)
    raise_errors(response)
    parse(response)
  end

  def raise_errors(response)
=begin
    case response.code.to_i
      when 401
        data = parse(response)
        raise RateLimitExceeded.new(data), "(#{response.code}): #{response.message} - #{data['error'] if data}"
    end
=end
  end
 
  def parse(response)
    Crack::JSON.parse(response.body)
  end

end
