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
#Create a core with "test" name that uses configSet "nutch_configs"
#instanceDir must exists before calling this command  
curl "http://localhost:8983/solr/admin/cores?action=CREATE&name=test&instanceDir=/opt/solr/example/solr/test&configSet=nutch_configs"
--------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------
#Delete core (or collection is solr is running in local mode)
curl "http://localhost:8983/solr/admin/cores?action=UNLOAD&deleteInstanceDir=true&core=test"
--------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------------
# Example of delete document by id
curl http://localhost:8983/solr/test/update?commit=true -H "Content-Type: text/xml" --data-binary '<delete><id>org.apache.nutch:http/</id></delete>'
-------------------------------------------------------------------------------------------------------------------------------------------------------

