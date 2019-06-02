
// window.$ = require('jquery');
// import $ from 'jquery';
require('../css/style.css');


require('./ws.js');
require('./chart.js');
require('./xlinx.js');
let cX=require('./main.html');
let rootx = document.getElementById("root");
let nodex = document.createElement("div");
nodex.async = true;
nodex.innerHTML = require('./main.html');
rootx.replaceWith(nodex);

// document.getElementById("root").appendChild(require('./main.html'));

// var sNew = document.createElement("script");
// sNew.async = true;
// sNew.src = require('./main.html');
// var s0 = document.getElementsByTagName('script')[0];
// s0.parentNode.insertBefore(sNew, s0);
// document.write(require('./main.html'));

