/*
	for retrieving validating discount codes from the server
*/
AeonVera.extendWith( "Discounts", {
  namespace: "Registration",
  functions: {

    dom: null,
    field: null,
    newDiscount: "<input name='attendance[discount_ids][]' type='hidden' />",

    init: function () {
      this.dom = $( "fieldset.discounts" );
      this.field = this.dom.find( "input[type='text']" );

      this.field.bind( "blur", this.Events.codeEntered );
    },

    isValidCode: function ( code ) {
      $.ajax( {
        url: AeonVera.event.id + "/valid_discount.js",
        data: {
          authenticity_token: window.AUTH_TOKEN,
          discount_code: code,
          id: AeonVera.event.id
        },
        complete: function ( jqXHR, textStatus ) {
          var data = JSON.parse( jqXHR.responseText );
          AeonVera.Registration.Discounts.showCode( data );
          /* hide the form so they can't put in more codes */
          if ( data.valid ) {
            $( "#discount" ).hide();
          }
        }
      } );
    },

    /*
			- apply the code
			- check if the event allows multiple discounts
			- add it to the array of discount ids
			- clear the field
		 */
    showCode: function ( options ) {
      if ( options[ "valid" ] ) {
        AeonVera.Registration.addLineItem( {
          name: this.field.val()
        } );

        AeonVera.notice( options[ "message" ] );

        /* add id to arry of discounts */
        var newDiscount = $( this.newDiscount );
        newDiscount.val( options[ "id" ] );
        this.dom.find( ".ids" ).append( newDiscount );

      } else {
        AeonVera.alert( options[ "message" ] );
      }

      /* clear field */
      // this.field.val( "" );
    },

    Events: {

      codeEntered: function ( event ) {
        var self = $( event.target );
        AeonVera.Registration.Discounts.isValidCode( self.val() )
      }
    }
  }
} );