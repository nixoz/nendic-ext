/**
 * 익스텐션 아이콘 관리 모듈
 * @author ohgyun@gmail.com
 * @version 2012.12.08
 */
define(function () {

  var baction = chrome.browserAction;

  return {

    setViewerOn: function () {
      baction.setBadgeText({
        text: 'on'
      });
      baction.setBadgeBackgroundColor({
        color: [91, 146, 255, 100]
      });
    },

    setViewerOff: function () {
      baction.setBadgeText({
        text: 'off'
      });
      baction.setBadgeBackgroundColor({
        color: [255, 0, 0, 100]
      });
    }

  };

});

