/**
 * requirejs optimizer 툴을 사용해 빌드한다.
 * (http://requirejs.org/docs/optimization.html)
 * 
 * 1. Optimizier가 없다면 `npm install requirejs -g`로 인스톨한다.
 * 2. `r.js -o build.js` 명령어로 빌드한다.
 *
 * # Build file example: https://github.com/jrburke/r.js/blob/master/build/example.build.js
 */
({
  baseUrl: "../src/js/lib",
  paths: {
    "requireLib": "./require",
    "common": "../common",
    "bg": "../bg",
    "baction": "../baction",
    "cscript": "../cscript"
  },

  // include require.js
  include: "requireLib",

  // main module
  name: "../cscript/cscript_main",
  
  // output filename
  out: "../release/js/cscript.min.js"
})