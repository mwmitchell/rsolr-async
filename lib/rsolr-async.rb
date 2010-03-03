raise RuntimeError, "EventMachine connection requires Ruby 1.9" if RUBY_VERSION < '1.9'

require 'rubygems'
require 'rsolr'
require 'em-http'
require 'fiber'

#
# Connection for EventMachine
#
module RSolr::Async
  
  module Connectable
    
    def connect *args, &blk
      if args.first == :async
        rsolr = RSolr::Client.new(RSolr::Async::Connection.new(*args[1..-1]))
        block_given? ? (yield rsolr) : rsolr
      else
        super *args, &blk
      end
    end
    
  end
  
  RSolr.extend RSolr::Async::Connectable
  
  #
  # Evented Connection for standard HTTP Solr server
  #
  class Connection
    
    include RSolr::Connection::Requestable
    
    REQUEST_CLASS = EM::HttpRequest
    
    protected
    
    def connection path
      REQUEST_CLASS.new("#{@uri.to_s}#{path}")
    end
    
    def timeout
      opts[:timeout] || 5
    end

    def get path, params={}
      # this yield/resume business is complicated by em-http's mocking support which
      # yields to the callback immediately rather than from another fiber.
      yielding = true
      fiber = Fiber.current
      http_response = self.connection(path).get :query => params, :timeout => timeout
      http_response.callback do
        yielding = false
        fiber.resume if Fiber.current != fiber
      end
      http_response.errback do
        yielding = false
        fiber.resume if Fiber.current != fiber
      end
      Fiber.yield if yielding
      create_http_context http_response, path, params
    end
    
    def post path, data, params={}, headers={}
      yielding = true
      fiber = Fiber.current
      http_response = self.connection(path).post :query => params, :body => data, :head => headers, :timeout => timeout
      http_response.callback do
        yielding = false
        fiber.resume if Fiber.current != fiber
      end
      http_response.errback do
        yielding = false
        fiber.resume if Fiber.current != fiber
      end
      Fiber.yield if yielding
      create_http_context http_response, path, params, data, headers
    end
    
    def create_http_context http_response, path, params, data=nil, headers={}
      full_url = "#{@uri.to_s}#{path}"
      {
        :status_code=>http_response.response_header.status,
        :url=>full_url,
        :body=>encode_utf8(http_response.response),
        :path=>path,
        :params=>params,
        :data=>data,
        :headers=>headers,
      }
    end
    
    # accepts a path/string and optional hash of query params
    def build_url path, params={}
      full_path = @uri.path + path
      super full_path, params, @uri.query
    end

  end
  
end