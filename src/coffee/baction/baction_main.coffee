###
브라우저 액션 메인 모듈
###
require [
  "common/pubsub"
  "baction/icon"
], (pubsub, icon) ->
  
  # 메시지 규칙
  # 1. 완료형으로만 보낸다.
  # 2. 소문자와 대시(-)를 사용한다.
  # 3. 컨텐트 스크립트에서 보낸 경우, 앞에 @- 를 붙인다.
  # 4. 백그라운드에 보낸 경우, 앞에 *- 를 붙인다.
  # 뷰어 활성화 여부
  _isViewerActivated = false
  
  # 최초엔 뷰어가 활성화되지 않은 상태로 설정한다.
  setViewerActivated false

  # 뷰어 활성화 여부를 설정한다.
  # 아이콘도 함께 업데이트한다.
  setViewerActivated = (isActivated) ->
    _isViewerActivated = isActivated

    if isActivated
      icon.setViewerOn()
    else
      icon.setViewerOff()
  
  # 탭이 업데이트 되었다는 메시지를 전달한다.
  # 메시지를 전달하기 전에 뷰어의 상태를 false로 설정한다.
  sendTabUpdated = ->
    setViewerActivated false
    pubsub.pub "*-tab-updated"

  # 네이버 영어사전 페이지를 새 탭으로 연다.
  openDictionaryPage = ->
    chrome.tabs.create
      url: "http://endic.naver.com"
      active: true
  
  # 컨텐츠의 내용이 바뀔 때마다 뷰어가 존재하는지 여부를 체크하고,
  # 그에 따라 아이콘을 바꾸고 링크를 설정해준다.
  # 탭의 내용이 바뀐 경우, 업데이트 되었다는 메시지를 보낸다.
  chrome.tabs.onUpdated.addListener sendTabUpdated
  # 다른 탭을 선택하거나, 새 탭을 생성한 경우에도 업데이트 되었다는 메시지를 보낸다.
  chrome.tabs.onHighlighted.addListener sendTabUpdated

  # 뷰어의 존재에 따른 메시지를 받아 상태를 설정한다.
  pubsub.sub "@-viewer-activated", ->
    setViewerActivated true

  pubsub.sub "@-viewer-inactivated", ->
    setViewerActivated false
  
  # 브라우저 액션 아이콘 클릭에 대한 이벤트를 등록한다.
  # 뷰어가 활성화되어 있는 경우 탭 내의 뷰어를 오픈할 수 있도록 메시지를 보내고,
  # 활성화되어 있지 않다면 사전 페이지로 이동한다.
  chrome.browserAction.onClicked.addListener (tab) ->
    if _isViewerActivated
      pubsub.pub "*-extension-icon-clicked"
    else
      openDictionaryPage()