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
    "cscript": "../cscript",
    "cscript/viewer": "../cscript/viewer"
  },

  // include require.js and viewer
  // 뷰어는 비동기로 로드되기 때문에 추가로 include에 넣어준다.
  include: [ "requireLib", "cscript/viewer/viewer" ],

  // main module
  name: "cscript/cscript_main",
  
  // output filename
  out: "../release/js/cscript.min.js"
})