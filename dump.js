var sqlite3 = require('sqlite-sync');
var path = require('path');
//sqlite3.connect(path.join(__dirname, './data/unihan.db'));
sqlite3.connect('/dev/shm/unihan.db');

var query = "SELECT * FROM unihan";
// Lookup character in sqlite db
var out = {};
sqlite3.runAsync(query, [], function(rows) {
  rows.forEach(function(row){
    out[row.character] = row;    
  });
});
console.log(JSON.stringify(out, null, 2));
