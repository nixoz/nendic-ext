# pubsub 모듈에서 chrome.tabs 이슈를 해결하기 위한 패치 코드
# https://github.com/ohgyun/nendic-ext/issues/17
gIsContentScript = true

###
컨텐트 스크립트의 메인 모듈
###
require [
  "jquery"
  "common/pubsub"
  "cscript/frameObserver"
], ($, pubsub, frameObserver) ->
  
  # 메시지 규칙
  # 1. 완료형으로만 보낸다.
  # 2. 소문자와 대시(-)를 사용한다.
  # 3. 컨텐트 스크립트에서 보낸 경우, 앞에 @- 를 붙인다.
  # 4. 백그라운드에서 보낸 경우, 앞에 *- 를 붙인다.
  
  _$doc = $(document)

  # 뷰어는 프레임이 활성화된 경우에 로드되며,
  # 로드되었을 때에 변수에 할당한다.
  _viewer = null


  # 뷰어를 로드하고 로드가 완료되면 콜백을 실행한다.
  loadViewer = (callback) ->
    if _viewer
      callback()
      return

    require ["cscript/viewer/viewer"], (v) ->
      _viewer = v
      bindViewerEventHandler()
      pubsub.pub "@-viewer-activated"
      callback()
  
  # 뷰어에 이벤트 핸들러를 설정한다. 
  # 뷰어가 로드된 이후에 붙인다.
  bindViewerEventHandler = ->
    # 한/영 전환     
    _viewer.onAction "toggleDicType", ->
      pubsub.pub "@-dic-type-toggle-btn-clicked"
  

  # 프레임에 마우스액션이 감지되었을 때
  # 프레임 활성화를 위한 메시지를 보낸다.
  # 이 메시지는 최초 한 번만 보낸다.
  _$doc.one "mousedown", (e) ->
    pubsub.pub "@-frame-observed",
      frameId: frameObserver.getFrameId()

  # 뷰어가 아닌 영역을 클릭한 경우, 뷰어를 닫는다. 
  _$doc.mousedown (e) ->
    # 뷰어 영역을 클릭했다면 무시한다.
    return if _viewer and _viewer.hasElement(e.target)
    
    # 뷰어가 포함되지 않은 프레임에서도 클릭 이벤트가 발생할 수 있으므로,
    # 익스텐션에서 이벤트를 받아 모든 프레임으로 보낸다.
    pubsub.pub "@-outofviewer-clicked"

  # 더블 클릭으로 텍스트 선택 시 단어를 검색한다.
  $(document).dblclick (e) ->
    target = e.target

    # 텍스트 입력창이라면 무시한다.
    return if /(input|textarea)/i.test(target.tagName)

    # 현재 선택한 문자열을 가져온다.
    selectionText = window.getSelection().toString().trim()

    if selectionText
      pubsub.pub("@-word-selected", query: selectionText)
  
  
  # 현재 프레임 정보를 수집해 전송한다. 
  pubsub.sub "*-frame-repos-reseted", ->
    frameInfo = frameObserver.getInfo()
    pubsub.pub "@-frame-info-collected", frameInfo

  # 활성화할 프레임을 찾았다는 정보를 받은 경우,
  # 해당 정보로 프레임을 활성화/비활성화한다.
  pubsub.sub "*-frame-newly-activated", (data) ->
    frameObserver.activate data.frameId
  
  # 뷰어 바깥 영역에 마우스 이벤트가 발생한 경우
  pubsub.sub "*-outofviewer-clicked", ->
    _viewer.close() if _viewer
  
  # 단어 검색이 완료된 경우
  pubsub.sub "*-word-searched", (data) ->
    # 프레임이 활성화 된 경우에만 뷰어를 로드한다.
    if frameObserver.isActivated()
      loadViewer ->
        _viewer.open data

  # 탭이 업데이트 된 경우
  # 뷰어 활성화 여부에 대한 메시지를 던져준다.
  pubsub.sub "*-tab-updated", ->
    if _viewer
      pubsub.pub "@-viewer-activated"
    else
      pubsub.pub "@-viewer-inactivated"

  # 익스텐션 아이콘을 클릭한 경우
  pubsub.sub "*-extension-icon-clicked", ->
    # 이 메시지는 뷰어가 활성화되어 있는 경우에만 전달된다.
    _viewer.open()