require 'benchmark'
require 'rsolr'
require 'rsolr-async'

# Bulk load a number of documents into Solr.
# Ensures that Solr commits the changes once per minute.
class BulkIndexer
  
  def index(docs)
    puts "indexing #{docs.size} docs"
    Benchmark.measure do
      docs.each_with_index do |doc,index|
        doc.merge!(:id => Time.now.to_f.to_s)
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
# ruby -Ilib examples/bulk_indexer.rb
#
# You will need to change doc to reflect the fields in your Solr's schema.xml.
doc = {
  'content' => <<-EOS
  Teams have doubled the number of scouts on the payroll over the last two decades to an average of 12 while their marketing departments, which are charged with keeping the revenue rolling in, have tripled in size to about 20 employees each. Moreover, teams have spent millions on training facilities, video-editing technology, nutritionists, specialized catering services and high-tech meeting rooms.

  Indianapolis linebackers coach Mike Murphy, who has been an NFL coach for more than two decades, says he remembers when computers, introduced in the 1990s, first eliminated the hours coaches used to spend splicing game film. But instead of going home at a reasonable hour, he says, coaches started working more. "We're so paranoid that we explore every possibility, every angle," he says. "You have so much information that you can confuse yourself. You can go nuts."
EOS
}
docs = Array.new(1000, doc)

EM.run do
  # We create 5 fibers, which allows us to run 5 I/O operations
  # in parallel.  In practice, you won't see a huge speedup if Solr
  # is running on localhost.  On my machine:
  # Indexing done in 4.698831 seconds with 1 concurrency
  # Indexing done in 3.898857 seconds with 2 concurrency
  # Indexing done in 3.520972 seconds with 5 concurrency
  
  a = Time.now
  concurrency = 5
  completed = 0
  concurrency.times do |idx|
   
    Fiber.new do
      bl = BulkIndexer.new
      bl.index(docs.slice(idx*(1000/concurrency), 1000/concurrency))
      completed += 1
      if completed == concurrency
        puts "Indexing done in #{Time.now - a} seconds with #{concurrency} concurrency"
        EM.stop
      end
    end.resume

  end
end