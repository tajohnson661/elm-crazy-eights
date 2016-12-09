// pull in desired CSS/SASS files
require( './styles/main.scss' );

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
var app = Elm.Main.embed( document.getElementById( 'main' ) );

// getTime is the outbound port request to get the time, and
// then we need to send it into the inbound port via the loadTime port
app.ports.getTime.subscribe(function() {
  app.ports.loadTime.send(Date.now());
})
