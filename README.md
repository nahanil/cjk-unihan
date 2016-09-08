## Overview
Simple interface to Unihan database for Node.js.

This library comes with:
  - The simple to use
  - An SQLite3 database populated with data from the Unihan database
  - Perl/bash scripts to generate said database, should you wish to update it, etc

## Usage
````javascript
var cjk_unihan = require("./index.js");

// Query a single field for a specified character
cjk_unihan.get("我", "kTotalStrokes", function(err, result){
  console.log("Single field lookup all done:", result);
  // Single field lookup all done: 7
});

// Get all available information about a character
cjk_unihan.get("我", function(err, result){
  console.log("Full lookup all done:", result);
  // Full lookup all done: { character: '我',
  //   SUnicode: '62.3',
  //   kIRGKangXi: '0412.010',
  //   ...
  //   ...
  // }
});
````

## Generating a fresh SQLite3 database
````bash
cd parser

# parser/data should contain a file which contains all the concatenated files downloaded from
# This file should be sorted by the first column, otherwise shit will break.

perl parse.pl < data/Unihan.sorted.txt > unihan.parsed

# Then we run the shell script to recreate the database file
create_db.sh
````

After this we should be set to go.
Ideally I will wrap this all up in some simple package that will download the latest copy from the web and automate all this fiddling around

## TODO
  - Tidy up database generation scripts
  - Automate download, concatenation, sorting of downloaded unihan txt files
  - Tests would be nice. Real ones and such
  - Tidy up the format of some data stored (Should currently be a 1:1 dump of the Unihan data)
    - ie, kHanyuPinyin should probably return an array of monosyllabic pronunciations, the rest of this field can be ignored when inserting to database
    - etc etc
