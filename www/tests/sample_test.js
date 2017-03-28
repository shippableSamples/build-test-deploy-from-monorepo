module.exports = {
  "test sample" : function (browser) {
    browser
      .url("http://127.0.0.1:5001")
      .waitForElementVisible('body', 1000)
      .assert.containsText('body', "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:44.0) Gecko/20100101 Firefox/44.0")
      .end();
  }
};
