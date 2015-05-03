window.AeonVera = {
	/* top level namespace needs a name. sub nampsaces' names are generated */
	name: "AeonVera",
	alert: function ( message ) {
		this.notify( message, "alert" );
	},
	notice: function ( message ) {
		this.notify( message, "notice" );
	},

	notify: function ( message, kind ) {
		var alertBox = $( "<div class='alert-box' id='" + kind + "'>" + message + "</div>" );

		$( "body" ).prepend( alertBox );
		setTimeout( function () {
			alertBox.slideUp( "slow", function () {
				alertBox.remove();
			} );
		}, 5000 );
	},

	initWindowObservers: function(){
		var self = this;
		$(window).on('flash', function(msg, kind){
			console.log(msg);
			console.log(kind);
			self.notify(msg, kind);
		})
	}
};