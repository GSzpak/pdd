Register 'lib.py' using org.apache.pig.scripting.jython.JythonScriptEngine as myfuncs;


urls = LOAD 'input/urls_pagerank.txt' USING PigStorage(',') AS
    (category:chararray, url:chararray, pagerank:double);
good_urls = FILTER urls BY pagerank > 0.4;
groups = GROUP good_urls BY category;
big_groups = FILTER groups BY COUNT(good_urls) > 3;
average_group = FOREACH big_groups GENERATE group, AVG(good_urls.pagerank);
STORE average_group INTO 'example1_out';

all_groups = GROUP urls by category;
top3 = FOREACH all_groups GENERATE group, myfuncs.top3(urls);
STORE top3 into 'example2_out';


map_result = FOREACH urls GENERATE FLATTEN(myfuncs.map_(*));
key_groups = GROUP map_result BY $0;
map_red = FOREACH key_groups GENERATE myfuncs.reduce(*);
STORE map_red into 'mapred_out';
