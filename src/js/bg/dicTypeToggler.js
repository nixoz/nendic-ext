/**
 * 영/한 사전 전환을 위한 모듈
 *
 * @author ohgyun@gmail.com
 * @version 2012.11.10
 */
define([], function () {

  // 한영/영영 사전을 전환한다.
  // 쿠키에 isOnlyViewEE 값을 Y로 설정하면 영영사전으로 응답이 온다.
  var url = "http://endic.naver.com/searchAssistDict.nhn",
    cookieName = "isOnlyViewEE";

  function toggle(onSuccess) {
  
    // 1. 쿠키를 가져오는 것이 완료되면, 
    chrome.cookies.get({
      "url": url,
      "name": cookieName
      
    }, function (cookie) {
      // 2. 쿠기값을 확인해 변경할 값을 정하고,
      var toggledValue;
      
      if (cookie === null || cookie.value === "N") {
        toggledValue = "Y";
      } else {
        toggledValue = "N";
      }
      
      // 3. 선택된 쿠키를 삭제한 후,
      // (fix: Mac OS에서 쿠키가 삭제되지 않고 append 되는 문제)
      chrome.cookies.remove({
        "url": url,
        "name": cookieName,
      }, function () {
        // 4. 쿠키를 다시 셋팅하고 검색 요청을 보낸다.
        chrome.cookies.set({
          "url": url,
          "name": cookieName,
          "value": toggledValue
        }, function (cookie) {
          onSuccess();
        });
      });
      
    });
  }

  return {
    toggle: toggle
  };

});
