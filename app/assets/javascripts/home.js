jQuery(document).ready( function ($) {
	if ( $( "body" ).hasClass( "terms_of_service" ) ) {
		var currentTextTitle = $( "span.for" );
		var terms = $( ".terms" );

		$( "header a" ).click( function ( e ) {
			var target = $( e.target );
			$( "header a" ).removeClass( "active" );
			target.addClass( "active" );
			terms.find( "article" ).hide();
			terms.find( "article." + target.data( "target" ) ).show();
			currentTextTitle.text( "(" + target.text() + ")" );
		} );
	}
} );
