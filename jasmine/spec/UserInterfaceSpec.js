describe("UserInterface", function() {
  var ui;
  var button;
  var textfield;
  var spinner;
  var output;
  var container;
  var h1;
  var h2;
  var exp_p;
  var body;

  beforeEach( function() {
    textfield = $('<input/>');
    button = $( '<button/>' );
    spinner = $( '<img/>' );
    output = $( '<div/>' );
    container = $( '<div/>' );
    h1 = $( '<h1/>' );
    h2 = $( '<h2/>' );
    exp_p = $( '<p/>' );
    body = $( '<body/>' );
    ui = user_interface( textfield, button, spinner, output, container, h2, h1, exp_p, body );
  });

  describe( 'initialising', function() {
    it( 'should set up click on button', function() {
      spyOn( button, 'click' );
      ui.init( button );
      expect( button.click ).toHaveBeenCalled();
    });
  });

  describe( 'in showLoading', function() {
    it( 'should hide input', function() {
      spyOn( textfield, "hide" );
      ui.showLoading();
      expect( textfield.hide ).toHaveBeenCalled();
    });
    it( 'should show loading spinner', function() {
      spyOn( spinner, "show" );
      ui.showLoading();
      expect( spinner.show ).toHaveBeenCalled();
    });
  });

  describe( 'in hideLoading', function() {
    it( 'should show input', function() {
      spyOn( textfield, "show" );
      ui.hideLoading();
      expect( textfield.show ).toHaveBeenCalled();
    });
    it( 'should hide loading spinner', function() {
      spyOn( spinner, "hide" );
      ui.hideLoading();
      expect( spinner.hide ).toHaveBeenCalled();
    });
  });

  describe( 'in addSearchTag', function() {
    it( 'should add search tag to document body', function() {
      spyOn( body, 'append' );
      ui.addSearchTag( 'foo' );
      expect( body.append ).toHaveBeenCalled();
    });
  });

  describe( 'in dispatchSpec', function() {
    describe( 'if input not empty', function() {
      it( 'should call showLoading and addSearchTag', function() {
        spyOn( ui, 'showLoading' );
        spyOn( ui, 'addSearchTag' );
        ui.dispatchSearch( 'foo' );
        expect( ui.showLoading ).toHaveBeenCalled();
        expect( ui.addSearchTag ).toHaveBeenCalledWith('foo');
      });
    });
    describe( 'if input empty', function() {
      it( 'should not call showLoading or addSearchTag', function() {
        spyOn( ui, 'showLoading' );
        spyOn( ui, 'addSearchTag' );
        var called = false;
        ui.dispatchSearch( null, function() { called = true; } );
        expect( ui.showLoading ).not.toHaveBeenCalled();
        expect( ui.addSearchTag ).not.toHaveBeenCalled();
        expect( called ).toBeTruthy();
      });
    });
  });

  describe( 'in postQuery', function() {
    it( 'should make ajax call', function() {
      spyOn($, 'ajax');
      ui.postQuery( 'foo' );
      expect( $.ajax ).toHaveBeenCalled();
    });
    describe( 'if call succeeds', function() {
      it( 'should update page', function() {
        spyOn( ui, 'updatePage' );
        spyOn($, "ajax").andCallFake(function(options) {
            options.success( { output:'data.output' } );
        });
        ui.postQuery( 'foo' );
        expect( ui.updatePage ).toHaveBeenCalledWith('data.output');
      });
    });
    describe( 'if call fails', function() {
      it( 'should update with error message', function() {
        spyOn( ui, 'updatePage' );
        spyOn($, "ajax").andCallFake(function(options) {
            options.error();
        });
        ui.postQuery( 'foo' );
        expect( ui.updatePage ).toHaveBeenCalledWith('Sorry something went wrong.');
      });
    });
    describe( 'when call complete', function() {
      it( 'should remove search script tag', function() {
        spyOn( ui, 'removeSearchTag' );
        spyOn($, "ajax").andCallFake(function(options) {
            options.complete();
        });
        ui.postQuery( 'foo' );
        expect( ui.removeSearchTag ).toHaveBeenCalled();
      });
    });
  });

  describe( 'updatePage', function() {
    it( 'should update text', function() {
      ui.updatePage( 'foo' );
    });
    it( 'should update text, header1 and explanation', function() {
      spyOn( output, 'text' );
      spyOn( h1, 'text' );
      spyOn( exp_p, 'text' );
      ui.updatePage( 'foo' );
      expect( output.text ).toHaveBeenCalledWith('foo');
      expect( h1.text ).toHaveBeenCalled();
      expect( exp_p.text ).toHaveBeenCalled();
    });
    it( 'should show container', function() {
      spyOn( h2, 'show' );
      ui.updatePage( 'foo' );
      expect( h2.show ).toHaveBeenCalled();
    });
  });
});
