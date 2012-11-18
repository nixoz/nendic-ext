/**
 * 익스텐션 스토리지 저장 모듈
 *
 * @author ohgyun@gmail.com
 * @version 2012.11.18
 */
define([], function () {

  /*
   * chrome.storage API를 사용하기 쉽게 추상화한다.
   * 다른 크롬 브라우저에서도 동기화하여 사용할 수 있게
   * 항상 sync 스토리지를 사용한다.
   * manifest의 permission 옵션에 storage를 추가해야 한다.
   */
  var storage = chrome.storage.sync;

  return {

    set: function (key, callback) {
      storage.set(key, callback);
    },

    get: function (key, callback) {
      storage.get(key, callback);
    }

  };

});
