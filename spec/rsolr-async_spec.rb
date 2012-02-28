require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'em-http'
require 'webmock/rspec'

describe RSolr do
  
  context 'initialization' do
    
    it 'should not change the default connect behavior' do
      RSolr.connect(:url => 'http://localhost:8983/solr').connection.should be_a(RSolr::Connection)
    end
    
    it 'should create an instance of RSolr::Async::Connection when :async is used' do
      RSolr.connect(RSolr::AsyncConnection, :url=>'http://localhost:8983/solr').connection.should be_a(RSolr::AsyncConnection)
    end
    
  end
  
  context '#request' do
    it 'should forward simple, non-data calls to #get' do
      
      EM.run do
        
        EM.add_timer(1) do
          EM.stop
        end
        
        body = <<-EOM
HTTP/1.1 200 OK
Date: Mon, 16 Nov 2009 20:39:15 GMT
Expires: -1
Cache-Control: private, max-age=0
Content-Type: text/xml; charset=utf-8
Connection: close

<?xml version="1.0" encoding="UTF-8"?>
<response>
<lst name="responseHeader"><int name="status">0</int><int name="QTime">1</int><lst name="params"><str name="q">a</str></lst></lst><result name="response" numFound="0" start="0"/>
</response>
EOM

        stub_request(:get, 'http://127.0.0.1:8983/solr/select?wt=ruby&q=a')
          .to_return(:body => body, :status => 200)
        
        Fiber.new do
          begin

            solr = RSolr.connect :url => 'http://127.0.0.1:8983/solr'
            rsp = solr.get 'select', params: { q: 'a' }
            rsp[:status_code].should == 200
          rescue Exception => ex
            puts ex.message
            puts ex.backtrace.join("\n")
          end
          EM.stop
        end.resume
      end
      
    end
  end
  
end