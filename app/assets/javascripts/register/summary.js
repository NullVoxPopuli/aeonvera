AeonVera.extendWith( "Summary", {
	namespace: "Registration",
	functions: {

		dom: null,
		init: function () {
			this.dom = $( ".summary" );
		},

		add: function ( lineItem ) {
			var line = $( "<tr><td>" + lineItem[ "name" ] + "</td><td>" + lineItem[ "price" ] + "</td></tr>" );
			this.dom.find( ".line-items" ).append( line );
		}

	}
} );