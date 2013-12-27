###
익스텐션 아이콘 관리 모듈
###
define ->
  baction = chrome.browserAction

  setViewerOn: ->
    baction.setBadgeText text: "on"
    baction.setBadgeBackgroundColor color: [91, 146, 255, 100]

  setViewerOff: ->
    baction.setBadgeText text: "off"
    baction.setBadgeBackgroundColor color: [255, 0, 0, 100]
