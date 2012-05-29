// SpecHelper.js
var jasmineExtensions = {
  jQuerySpies: {},
  spyOnEvent: function(element, eventName) {
    var control = {
      triggered: false
    };
    element.bind(eventName, function() {
      control.triggered = true;
    });
    jasmineExtensions.jQuerySpies[element[eventName]] = control;
  }
};

var spyOnEvent = jasmineExtensions.spyOnEvent;

beforeEach(function() {
  this.addMatchers({
    toHaveBeenTriggered: function() {
      var control = jasmineExtensions.jQuerySpies[this.actual];
      return control.triggered;
    }
  });
});

