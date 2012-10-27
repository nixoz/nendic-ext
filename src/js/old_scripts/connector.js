/**
 * 익스텐션과 컨텐츠 스크립트의 통신을 담당하는 모듈
 *
 * @module connector
 * @author ohgyun@gmail.com
 * @version 2012.10.27
 */
define([

  'jquery'
  
], function ($) {
  
  /**
   * 익스텐션으로 오는 요청 처리를 위한 핸들러를 등록한다.
   */
  function bindRequestEventListener() {
    chrome.extension.onRequest.addListener(
      function (request, sender, sendResponse) {
        var command = request.command,
          data = request.data,
          tabId = sender.tab.id;
        
        if (command) {
          doAction(command, data, tabId);
        }
      
        sendResponse({});
      }
    );
  }
  
  /**
   * 커맨드에 해당하는 액션을 수행한다.
   * action 목록에 커맨드가 있을 경우 수행하고,
   * 없는 경우 받은 명령을 응답으로 돌려보낸다.
   * (단순히 익스텐션을 통해 명령을 포워딩하는 목적)
   *
   * @param {string} command
   * @param {*} data
   * @param {string} tabId 호출된 탭의 아이디
   */
  function doAction(command, data, tabId) {
    var action = actionManager[command];
    if (typeof action === 'function') {
      action(data, tabId);
      
    } else {
      // 해당하는 명령이 없을 경우 그대로 보낸다.
      chrome.tabs.sendRequest(tabId, {
        'command': command,
        'data': data
      });
    }
  }
  
  return {
    init: function () {
      createContextMenu();
      bindRequestEventListener();
    },
    searchWord: function (query) {
      searchWord(query);
    },
    searchWordWithRecentQuery: function () {
      searchWord(_recentQuery);
    }
  };
  
});