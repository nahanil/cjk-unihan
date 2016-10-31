var sqlite3 = require('sqlite3').verbose();
var path = require('path');
var db = new sqlite3.Database(path.join(__dirname, './data/unihan.db'));

(function(){
  var instance;

  function Unihan() { }

  Unihan.prototype.get = function(key, field, callback) {
    if (!callback && typeof field == "function") {
      callback = field;
      field = null;
    }

    // Lookup character in sqlite db
    var query = "SELECT " + (field ? field : "*") + " FROM unihan WHERE character = ? limit 1";
    db.get(query, key, function(err, row) {
      if (err) {
        return callback(err);
      }

      // If nothing was found...
      if (!row) {
        return callback();
      }

      // Return all data or single field?
      var result = field ? row[field] : row;
      callback(null, result);
    });
  }

  if (!instance) {
    instance = new Unihan;
  }

  module.exports = instance;
}());
