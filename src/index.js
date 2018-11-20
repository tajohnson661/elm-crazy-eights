'use strict';

require("./styles.scss");

const { Elm } = require('./elm/Main');
var app = Elm.Main.init({ flags: 6 });

// getTime is the outbound port request to get the time, and
// then we need to send it into the inbound port via the loadTime port
app.ports.getTime.subscribe(function () {
    app.ports.loadTime.send(Date.now());
});

// Use ES2015 syntax and let Babel compile it for you
var testFn = (inp) => {
    let a = inp + 1;
    return a;
}
