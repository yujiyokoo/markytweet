user_interface = function ( input, btn, spn, output, container, h2, h1, exp_para, body_elem) {
  var textfield = input;
  var button = btn;
  var spinner = spn;
  var output_txt = output;
  var output_container = container;
  var header2 = h2;
  var header1 = h1;
  var explanation_p = exp_para;
  var body = body_elem;

  return {
    showLoading: function() {
      textfield.hide();
      button.hide();
      spinner.show();
    },

    hideLoading: function () {
      spinner.hide();
      textfield.show();
      button.show();
    },

    updatePage: function( strdata ) {
      output_txt.text( strdata );
      output_container.show();
      header2.show();
      header1.text( 'Your next tweet (possibly!)' );
      explanation_p.text( 'You could (but probably not) use this as your next tweet:' );
      this.hideLoading();
    },

    addSearchTag: function( input_val ) {
      var script = $( '<script/>' );
      script.attr( 'type', 'text/javascript' );
      script.attr( 'src', 'http://search.twitter.com/search.json?rpp=100&callback=ui.postQuery&q=' + encodeURI(input_val) );
      script.attr( 'id', 'twitter_search_results' );
      body.append( script );
    },

    removeSearchTag: function() {
      $('#twitter_search_results').remove();
    },

    old_addSearchTag: function( input_val ) {
      var script = document.createElement( 'script' );
      script.type = 'text/javascript';
      script.src = 'http://search.twitter.com/search.json?rpp=100&callback=ui.postQuery&q=' + encodeURI(input_val);
      script.id = 'twitter_search_results';
      document.body.append( script );
    },

    dispatchSearch: function ( input_val, message_fn ) {
      if( input_val ) {
        this.showLoading();
        this.addSearchTag( input_val );
      } else {
        message_fn();
      }
    },

    init: function ( button ) {
      ui = this;
      button.click( function() {
        ui.dispatchSearch( $('#input_query').val(), function() { alert( "Please enter query." ); } );
        return false;
      });
    },

    postQuery: function(jsonData) {
      ui = this;
      $.ajax({
        url: '/next_tweet/create.json',
        data: { 'search_results': jsonData },
        type: 'POST',
        error: function(jqXHR, textStatus, errorThrown) {
          ui.updatePage( 'Sorry something went wrong.' );
        },
        success: function(data) {
          ui.updatePage( data.output );
        },
        complete: function() {
          ui.removeSearchTag();
        }
      });
    }

  }
}

$(document).ready( function() {
  ui = new user_interface(
    $('input#input_query'),
    $('input#generate_button'),
    $('.loading'),
    $('blockquote.generated p'),
    $('blockquote.generated'),
    $('h2.resultpage'),
    $('div#header h1'),
    $('p.explanation'),
    $('body')
  );
  ui.init( $('#generate_button') );
  if( getParameterByName( 'query' ) ) {
    $('input#input_query').val( getParameterByName( 'query' ) );
    $('input#generate_button').trigger( 'click' );
  }
});

// from http://stackoverflow.com/questions/901115/get-query-string-values-in-javascript
function getParameterByName(name)
{
  name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
  var regexS = "[\\?&]" + name + "=([^&#]*)";
  var regex = new RegExp(regexS);
  var results = regex.exec(window.location.search);
  if(results == null)
    return "";
  else
    return decodeURIComponent(results[1].replace(/\+/g, " "));
}
