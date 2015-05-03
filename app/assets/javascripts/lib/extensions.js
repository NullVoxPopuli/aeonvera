/* 
	this is an expensive method O(n), if the object doesn't have a name attribute
*/
Object.defineProperty( Object.prototype, "varName", {
	value: function () {
		if ( this.name !== undefined ) {
			return this.name;
		} else {
			for ( var name in window ) {
				if ( window[ name ] == this ) {
					return name;
				}
			}
		}
	}
} );

/**
  'dynamically' extend objects to have sub objects even if a namespace isn't defined yet
 
 	Note: this function requires that an object have a 'name' attribute.
 			ie: window[this.name] === this
 		for extending named objects
 	Note: this function requires jQuery ($.extend)
 		
  @param  {String} name    name of the new nested object
  @param  {Object} options 
	- [String] namespace (Optional) - name of the object to add this new object to.
		This is a string, such that we can, at runtime, add nested objects that
			haven't yet been defined.
		Examples:
			"UITools"
			"UITools.TableOfContents"
	- [Object] functions - JSON structured format of local variables and functions for 
		this new object.
		Example:
			{
				dom: null,
				init: function(params){
					code here 
				}
			}
*/
Object.defineProperty( Object.prototype, "extendWith", {
	value: function ( name, options ) {

		var defaults = {
			namespace: null,
			functions: {}
		}
		var options = $.extend( {}, defaults, options );

		/* 
		build out the namespace if it hasn't existed prior to when this is invoked 
	*/
		var parent = window[ this.name ];
		// var currentParent = parent;
		if ( !! options.namespace ) {
			var objects = options.namespace.split( "." );
			var currentObject = null;
			for ( var i = 0; i < objects.length; i++ ) {
				currentObjectName = objects[ i ];
				/*
				if the object doesn't exist, create it.
				select the object and assign to parent 
				for nested namespaces.
			*/
				if ( !parent[ currentObjectName ] ) {
					parent[ currentObjectName ] = {
						name: currentObjectName,
						parent: parent
					}
				}
				parent = parent[ currentObjectName ];
			}

		}
		/*
		force the name to be the object name
		also, force parent so we can climb up the tree if we need to
	*/
		options.functions[ "name" ] = name;
		options.functions[ "parent" ] = parent;

		/* 
		finally, add it to the parent 
	*/
		parent[ name ] = parent[ name ] || {};
		$.extend( parent[ name ], options.functions );
	}
} );