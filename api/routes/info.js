'use strict';

module.exports = info;
var fs = require('fs');

function info(req, res) {
  var buildnum = 'unavailable';
  logger.info('Info page');
  fs.readFile('./shippable/buildoutput/config.txt', 'utf8',
    function (err, data) {
      if (err)
        console.log(err);
      if (data) buildnum = data.replace('\n', '');
      res.status(200).json({
        time: new Date(),
        buildnumber: buildnum,
        message: 'Docker based API micro service',
        body: req.body,
        query: req.query,
        params: req.params,
        method: req.method
      });
    }
  );
}
