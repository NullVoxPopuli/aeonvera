$.fn.isAfter = function ( sel ) {
	return this.nextAll( sel ).length > 0;
}
$.fn.isBefore = function ( sel ) {
	return this.prevAll( sel ).length > 0;
}


/* http://stackoverflow.com/a/5086688/356849 */
$.fn.insertAt = function ( index, element ) {
	var lastIndex = this.children().size()
	if ( index < 0 ) {
		index = Math.max( 0, lastIndex + 1 + index )
	}
	this.append( element )
	if ( index < lastIndex ) {
		this.children().eq( index ).before( this.children().last() )
	}
	return this;
}