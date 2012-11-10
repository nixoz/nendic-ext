/**
 * 뷰어의 단축키 모듈
 *
 * @author ohgyun@gmail.com
 * @version 2012.11.10
 */
define([
  'jquery'
], function ($) {

  var ALPHABET  = [
      'a','b','c','d','e','f','g','h','i','j','k','l','m',
      'n','o','p','q','r','s','t','u','v','w','x','y','z'
    ],
    SPECIAL = {
      27: 'esc',
      191: '/'
    },

    _callbackMap = {};
  
  // keydown으로 바인딩하면,
  // 한글일 때 키코드를 정확히 찾지 못하는 버그가 있다.
  // keyup으로 이벤트를 할당한다.
  $(document).on('keyup', function (e) {
    var key = findKey(e.keyCode);
    if ( ! key) { return; }

    var cbs = _callbackMap[key];
    if ( ! cbs) { return; }

    for (var i = 0; i < cbs.length; i++) {
      cbs[i]();
    }
  });

  function findKey(keyCode) {
    if (keyCode >= 65 && keyCode <= 90) {
      return ALPHABET[keyCode - 65];
    }
    return SPECIAL[keyCode];
  }
  
  return {

    /**
     * 단축키 콜백을 할당한다.
     * 
     * @param {string} key 키명. 'a', 'b'와 같은 키 이름
     * @param {function} callback 실행할 콜백
     * @param {function} when 콜백을 실행할 조건
     */
    on: function(key, callback, when) {
      _callbackMap[key] = _callbackMap[key] || [];
      _callbackMap[key].push(function () {
        switch (typeof when) {
        case 'undefined':
          callback();
          break;

        case 'function':
          when() && callback();
          break;

        default:
          when && callback();
        }
      });
      return this;
    }

  };

});
