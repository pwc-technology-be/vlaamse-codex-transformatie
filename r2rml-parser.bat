@echo off
@echo %time%
echo Transforming the data... Run with -h for help on options.
java -Xms512m -Xmx8g -cp "./*;./lib/*;" gr.seab.r2rml.beans.Main %1 %2
echo Transformation of data done.
@echo %time%
curl --digest --user dba:dba -vvv --url "http://localhost:8890/sparql-graph-crud-auth?graph-uri=https://data.vlaanderen.be/ns/wetgeving" -X PUT -T dump.nt
echo Data uploaded into the triple store.
@echo %time%
