require 'benchmark'
require 'rsolr'
require 'rsolr-async'

# Bulk load a number of documents into Solr.
# Ensures that Solr commits the changes once per minute.
class BulkIndexer
  
  def index(docs)
    Benchmark.measure do
      docs.each do |doc|
        result = rsolr.update(rsolr.message.add(doc, :commitWithin => 60000), :wt => 'ruby')
        raise RuntimeError, result if result !~ /'status'=>0/
      end
    end
  end
  
  private
  
  def rsolr
    @solr ||= RSolr.connect(:async, :url => 'http://localhost:8983/solr')
  end
end

# Use like so:
#
# ruby -Ilib examples/indexer.rb
#
# You will need to change doc to reflect the fields in your Solr's schema.xml.
doc = {
  'text' => <<-EOS
  Teams have doubled the number of scouts on the payroll over the last two decades to an average of 12 while their marketing departments, which are charged with keeping the revenue rolling in, have tripled in size to about 20 employees each. Moreover, teams have spent millions on training facilities, video-editing technology, nutritionists, specialized catering services and high-tech meeting rooms.

  Indianapolis linebackers coach Mike Murphy, who has been an NFL coach for more than two decades, says he remembers when computers, introduced in the 1990s, first eliminated the hours coaches used to spend splicing game film. But instead of going home at a reasonable hour, he says, coaches started working more. "We're so paranoid that we explore every possibility, every angle," he says. "You have so much information that you can confuse yourself. You can go nuts."
EOS
}
docs = Array.new(100, doc)
bl = BulkIndexer.new

EM.run do
  Fiber.new do
    bl.index(docs)
    EM.stop
  end.resume
end