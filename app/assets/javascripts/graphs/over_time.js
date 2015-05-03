$( function () {
  function timeChart( data, selector ) {
    nv.addGraph( function () {
      var chart = nv.models.lineChart()
        .x( function ( d ) {
          /* multiply by 1000 to get javascript time */
          return d[ 0 ] * 1000
        } )
        .y( function ( d ) {
          return d[ 1 ]
        } )
        .clipEdge( true )
        .useInteractiveGuideline( true );

      chart.xAxis
        .showMaxMin( true )
        .tickFormat( function ( d ) {
          return d3.time.format( '%x' )( new Date( d ) )
        } );

      d3.select( selector )
        .datum( data )
        .transition().duration( 500 )
        .call( chart );

      nv.utils.windowResize( chart.update );

      return chart;
    } );
  }
  d3.json( 'charts.json', function ( data ) {
    timeChart( data.registrations, "#chart svg.registrations" );
    timeChart( data.revenue, "#chart svg.revenue" )
  } );
} );