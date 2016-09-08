var cjk_unihan = require("./index.js");

cjk_unihan.get("我", function(err, result){
  console.log("Full lookup all done:", result);
});

cjk_unihan.get("我", "kTotalStrokes", function(err, result){
  console.log("Single field lookup all done:", result);
});
