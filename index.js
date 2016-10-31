var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database('./data/unihan.db');

(function(){
  var instance;

  function Unihan() { }

  Unihan.prototype.get = function(key, field, callback) {
    if (!callback && typeof field == "function") {
      callback = field;
      field = null;
    }

    var query = "SELECT " + (field ? field : "*") + " FROM unihan WHERE character = '"+ key +"'";

    db.all(query, function(err, rows) {
      if (err) {
        return callback(err);
      }

      // If nothing was found...
      if (!rows || !rows.length) {
        return callback();
      }

      // Return all data or single field?
      var result = field ? rows[0][field] : rows[0];
      callback(null, result);
    });
  }

  if (!instance) {
    instance = new Unihan;
  }

  module.exports = instance;
}());
