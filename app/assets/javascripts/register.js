//= require_self
//= require_tree ./register

AeonVera.extendWith( "Registration", {
  functions: {
    init: function () {
      this.Housing.init();
      this.Discounts.init();
      this.Summary.init();
    },
    addLineItem: function ( lineItem ) {
      this.Summary.add( lineItem );
    }
  }
} );

$( function () {
  AeonVera.Registration.init();


  $( ".packages input" ).click( function () {
    var self = $( this );
    var id = self.val().toString();

    if ( EVENT.packages[ id ].requires_track ) {
      $( ".levels" ).slideDown( 200 );
    } else {
      $( ".levels" ).slideUp( 200 );
    }
  } );


  $( ".info-toggle" ).click( function () {
    var self = $( this );
    var icon = self.find( "i" );
    if ( icon.hasClass( "fa-caret-down" ) ) {
      icon.removeClass( "fa-caret-down" );
      icon.addClass( "fa-caret-right" );
      $( ".info-container" ).slideUp();
    } else {
      icon.addClass( "fa-caret-down" );
      icon.removeClass( "fa-caret-right" );
      $( ".info-container" ).slideDown();
    }
  } )
} );