#!/usr/bin/env bash 
# Modified from http://sqlite.1065341.n5.nabble.com/How-to-import-data-from-stdin-td4940.html

rm -f ../data/unihan.db 
sqlite3 ../data/unihan.db '.read importfile.sql' 
