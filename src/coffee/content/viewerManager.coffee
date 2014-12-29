###
사전을 보여줄 iframe을 생성하고, iframe의 on/off를 담당한다.
페이지가 시작될 때 최상위 프레임에 추가한다.
###

_$viewer = null
_isAttached = false
_currentViewerHeight = 0
DEFAULT_HEIGHT = 168

#--------------------
# Functions
#--------------------
createViewer = ->
  _$viewer = $('<iframe>')
    .attr
      id: constant_.ID
      src: chrome.extension.getURL 'viewer.html'

showViewer = ->
  # DOM에는 최초에 한 번만 추가한다.
  unless _isAttached
    _$viewer.appendTo document.documentElement
    _isAttached = true
  _$viewer.addClass 'on'
  attachExpandEvent()
  preventDocumentWheelEvent()

expandViewerHeight = ->
  if _currentViewerHeight <= DEFAULT_HEIGHT
    properHeight = DEFAULT_HEIGHT
  else
    maxHeight = Math.floor($(window).height() * 0.9)
    properHeight = Math.min(_currentViewerHeight, maxHeight)

  _$viewer.attr 'style', "height: #{properHeight}px !important"

restoreViewerHeight = ->
  _$viewer.removeAttr 'style'
  
hideViewer = ->
  return unless _$viewer
  _$viewer.removeClass 'on'

  restoreViewerHeight()
  detachExpandEvent()
  allowDocumentWheelEvent()

# 전체 내용을 보기 편하도록, 마우스를 올릴 때 창을 확장하고 닫을 때 기본 크기로 줄인다.
attachExpandEvent = ->
  # 이벤트가 한 번만 실행되도록 하기 위해 기존 이벤트는 제거한다.
  detachExpandEvent()
  _$viewer.one 'mouseover', expandViewerHeight

detachExpandEvent = ->
  _$viewer.off 'mouseover'

# 뷰어 iframe 위에서 스크롤 시, 문서의 스크롤을 막는다.
preventDocumentWheelEvent = ->
  allowDocumentWheelEvent()
  $(document).on "wheel.#{constant_.ID}", (e) ->
    e.preventDefault() if e.target.id is constant_.ID

allowDocumentWheelEvent = ->
  $(document).off "wheel.#{constant_.ID}"

setCurrentViewerHeight = (height) ->
  _currentViewerHeight = height

whenWordSearched = message_.createListenerToExtension 'B:wordSearched'
whenOutsideClicked = message_.createListenerToExtension 'B:outsideClicked'
whenViewerRendered = message_.createListenerToExtension 'B:viewerRendered'

#--------------------
# Main Tasks
#--------------------
createViewer()

whenWordSearched showViewer
whenOutsideClicked hideViewer
whenViewerRendered setCurrentViewerHeight