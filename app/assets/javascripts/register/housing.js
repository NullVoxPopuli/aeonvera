AeonVera.extendWith( "Housing", {
  namespace: "Registration",
  functions: {

    dom: null,

    init: function () {
      this.dom = $( "fieldset.housing" );
      this.Need.init();
      this.Provide.init();
    },

    Need: {

      checkbox: null,
      information: null,
      checkboxID: "attendance_needs_housing",

      init: function () {
        this.checkbox = AeonVera.Registration.Housing.dom.find( "#" + this.checkboxID );
        this.checkbox.change( this.Events.change );
        this.information = this.checkbox.closest( "li" ).find( ".information" );
      },

      show: function () {
        this.information.slideDown();
      },

      hide: function () {
        this.information.slideUp();
        this.checkbox.prop( "checked", false );
      },

      Events: {
        change: function ( event ) {
          var self = $( this );
          var checked = self.prop( "checked" );
          if ( checked ) {
            AeonVera.Registration.Housing.Need.show();
            AeonVera.Registration.Housing.Provide.hide();
          } else {
            AeonVera.Registration.Housing.Need.hide();
          }
        }
      }
    },
    Provide: {

      checkbox: null,
      information: null,
      checkboxID: "attendance_providing_housing",

      init: function () {
        this.checkbox = AeonVera.Registration.Housing.dom.find( "#" + this.checkboxID );
        this.checkbox.change( this.Events.change );
        this.information = this.checkbox.closest( "li" ).find( ".information" );
      },

      show: function () {
        this.information.slideDown();
      },
      hide: function () {
        this.information.slideUp();
        this.checkbox.prop( "checked", false );
      },

      Events: {
        change: function ( event ) {
          var self = $( this );
          var checked = self.prop( "checked" );
          if ( checked ) {
            AeonVera.Registration.Housing.Need.hide();
            AeonVera.Registration.Housing.Provide.show();
          } else {
            AeonVera.Registration.Housing.Provide.hide();
          }
        }
      }
    }
  }
} )