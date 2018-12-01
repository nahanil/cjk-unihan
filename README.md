## cjk-unihan [![npm version](https://badge.fury.io/js/cjk-unihan.svg)](https://www.npmjs.com/package/cjk-unihan)
Simple interface to Unihan database for Node.js. Created for use on [HanziPal](https://www.hanzipal.com) & available on [NPM](https://www.npmjs.com/package/cjk-unihan)

This library comes with:
  - The simple to use node.js module for query Unihan data
  - An SQLite3 database populated with data from the Unihan database
  - Perl/bash scripts to generate said database, should you wish to update it, etc

## Usage
````javascript
var cjk_unihan = require("cjk-unihan");

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

# parser/data should contain a file which contains all the concatenated files downloaded from http://www.unicode.org/Public/UCD/latest/
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

# Danger, Will Robinson!
It's very early days here. I'm sure there was another module that I used to use for this purpose, but I can't find it for the life of me so here this is.
I expect the API calls to remain much the same as I work on this - it's a simple wrapper around a database to 'get' certain information, and doesn't need to do anything more.

The data returned however will be tidied up, change, prodded, poked, tweaked and modified until I am happier with it. If this happens I will increment version numbers accordingly, but I thought I'd add the Buyer Beware sticker before putting this out in the world.
