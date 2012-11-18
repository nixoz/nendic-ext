/**
 * 구글 애널리틱스 모듈
 *
 * @author ohgyun@gmail.com
 * @version 2012.11.18
 */
define([], function () {

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-30985671-2']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = 'https://ssl.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

  return {

    track: function (name, value) {
      _gaq.push(['_trackEvent', name, value]);
    }

  };
  
});
