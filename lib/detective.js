(function() {
  var coffee, detective;

  detective = require('detective');

  coffee = require('coffee-script');

  module.exports = function(source, ext) {
    var compiled;
    compiled = (function() {
      switch (ext) {
        case '.coffee':
          return coffee.compile(source);
        case '.js':
          return source;
        default:
          return '';
      }
    })();
    return detective(compiled).filter(function(id) {
      return /^[^\.]/.test(id);
    });
  };

}).call(this);
