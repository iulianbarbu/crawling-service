------------------------------------------------------------------------------------------------
# Example of using nutch with solr 

# start nutch gora backend storing database
1. start-hbase.sh

2. solr start

# "test" is the core where crawling data will be indexed to
# "urls/seed.txt" is a relative directory to /opt/nutch/runtime/local with urls to crawl
3. bin/crawl urls/seed.txt test http://localhost:8983/solr/test 1
------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------
#Create a core with "test" name that uses configSet "nutch_default"
#instanceDir must exists before calling this command  
curl "http://localhost:8983/solr/admin/cores?action=CREATE&name=test&instanceDir=/home/iulian/Licenta/solr-7.3.1/server/solr/cores/test&configSet=nutch_default"
--------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------
#Delete core (or collection is solr is running in local mode)
curl "http://localhost:8983/solr/admin/cores?action=UNLOAD&deleteInstanceDir=true&core=test"
--------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------------
# Example of delete document by id
curl http://localhost:8983/solr/test/update?commit=true -H "Content-Type: text/xml" --data-binary '<delete><id>org.apache.nutch:http/</id></delete>'
-------------------------------------------------------------------------------------------------------------------------------------------------------

# Distributed nutch inject
hdfs dfs -put urls /urls
bin/nutch inject /crawl /urls

# Distributed nutch generate
bin/nutch generate /crawl /crawl/segments

# Distributed nutch fetch
bin/nutch fetch /crawl/segments/id -threads N

# Benchmark
bin/nutch benchmark -depth 1 -threads 1 -seeds 6 -plugins "protocol-selenium|parse-tika|scoring-opic|urlfilter-regex|urlnormalizer-pass"

