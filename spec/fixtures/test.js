(function(app) {
  var m = app.add_module('test');
  m.set_data({
    some_prop: 'some value'
  });
  m.elements({
    test: $('.foo');
  });
  m.actions = function() {

  };

  m.run();
})();
