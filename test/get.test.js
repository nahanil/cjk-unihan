const unihan = require("../")

describe('get', () => {
  it ('get cb', (done) => {
    unihan.get("我", function(err, result){
      expect(result.kJapaneseKun).toEqual('WARE WA')
      done()
    })
  })

  it ('get strokes cb', (done) => {
    unihan.get("我", "kTotalStrokes", function(err, result){
      expect(result).toEqual('7')
      done()
    });
  })
})
