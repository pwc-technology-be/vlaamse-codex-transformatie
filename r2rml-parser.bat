@echo off
echo Transforming the data... Run with -h for help on options.
java -Xms512m -Xmx4096m -cp "./*;./lib/*;" gr.seab.r2rml.beans.Main %1 %2
echo Transformation of data done.
curl --digest --user dba:dba -vvv --url "http://localhost:8890/sparql-graph-crud-auth?graph-uri=https://data.vlaanderen.be/ns/wetgeving" -X POST -T dump.rdf
echo Data uploaded into the triple store.
