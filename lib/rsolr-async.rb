raise RuntimeError, "EventMachine connection requires Ruby 1.9" if RUBY_VERSION < '1.9'

require 'rubygems'
require 'rsolr'
require 'em-http'
require 'fiber'

module RSolr
  # The em-http-request adapter for RSolr.
  class AsyncConnection

    # using the request_context hash,
    # send a request,
    # then return the standard rsolr response hash {:status, :body, :headers}
    def execute client, request_context
      raise "Only :get, :post and :head http method types are allowed." unless [:get, :post, :head].include? request_context[:method]

      h = http request_context[:uri], request_context[:proxy], request_context[:read_timeout], request_context[:open_timeout]
      options = {
        head: request_context[:headers] || {}
      }
      options[:body] = request_context[:data] if request_context[:method] == :post and request_context[:data]
      options[:proxy][:authorization] = request_context[:proxy].userinfo.split(/:/) if request_context[:proxy] and request_context[:proxy].userinfo

      # this yield/resume business is complicated by em-http's mocking support which
      # yields to the callback immediately rather than from another fiber.
      fiber = Fiber.current
      yielding = true

      request = h.send request_context[:method], options
      request.callback do
        yielding = false
        fiber.resume if Fiber.current != fiber
      end
      request.errback do
        yielding = false
        fiber.resume if Fiber.current != fiber
      end
      if yielding
        result = Fiber.yield 
        raise result if result.kind_of?(Exception)
      end

      {
        status: request.response_header.status,
        headers: request.response_header.to_hash,
        body: request.response
      }
    end

    protected

    # This returns a singleton of a Net::HTTP or Net::HTTP.Proxy request object.
    def http uri, proxy = nil, read_timeout = nil, open_timeout = nil
      @http ||= (
        options = {
          connect_timeout: open_timeout,
          inactivity_timeout: read_timeout
        }
        options[:proxy] = {
          host: proxy.host,
          port: proxy.port
        } if proxy

        EventMachine::HttpRequest.new uri, options
      )
    end
  end
end
