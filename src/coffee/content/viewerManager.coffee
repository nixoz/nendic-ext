###
사전을 보여줄 iframe을 생성하고, iframe의 on/off를 담당한다.
페이지가 시작될 때 최상위 프레임에 추가한다.
###
@define 'viewerManager', ($$constant, $$message, $$analytics) ->
  DEFAULT_HEIGHT = 168

  _$viewer = null
  _isAttached = false
  _currentViewerHeight = 0
  _isViewerOpened = false

  # 뷰어가 닫히자 마자 다시 열리는 경우를 대비해 (사전 전환이나 빠른 클릭 등)
  # 닫을 때 딜레이를 준다.
  _hideTimer = null

  #--------------------
  # Functions
  #--------------------
  createViewer = ->
    _$viewer = $('<iframe>')
      .attr
        id: $$constant.ID
        src: chrome.extension.getURL 'viewer.html?init=true' # 초기화 옵션을 전달한다

  showViewer = ->
    # DOM에는 최초에 한 번만 추가한다.
    unless _isAttached
      _$viewer.appendTo document.documentElement
      _isAttached = true

    clearTimeout _hideTimer
    _hideTimer = null

    _$viewer.addClass 'on'
    _isViewerOpened = true

    attachExpandEvent()
    preventDocumentWheelEvent()

  # 전체 내용을 보기 편하도록, 마우스를 올릴 때 창을 확장하고 닫을 때 기본 크기로 줄인다.
  attachExpandEvent = ->
    # 이벤트가 한 번만 실행되도록 하기 위해 기존 이벤트는 제거한다.
    detachExpandEvent()
    _$viewer.one 'mouseover', expandViewerHeight

  detachExpandEvent = ->
    _$viewer.off 'mouseover'

  expandViewerHeight = ->
    if _currentViewerHeight <= DEFAULT_HEIGHT
      properHeight = DEFAULT_HEIGHT
    else
      maxHeight = Math.floor($(window).height() * 0.9)
      properHeight = Math.min(_currentViewerHeight, maxHeight)

    _$viewer.attr 'style', "height: #{properHeight}px !important"

    $$analytics.trackEvent('viewer:expand')

  # 뷰어 iframe 위에서 스크롤 시, 문서의 스크롤을 막는다.
  preventDocumentWheelEvent = ->
    allowDocumentWheelEvent()
    $(document).on "wheel.#{$$constant.ID}", (e) ->
      e.preventDefault() if e.target.id is $$constant.ID

  restoreViewerHeight = ->
    _$viewer.removeAttr 'style'
    
  allowDocumentWheelEvent = ->
    $(document).off "wheel.#{$$constant.ID}"

  hideViewer = ->
    return unless _$viewer
    return unless _isViewerOpened

    _isViewerOpened = false

    _hideTimer = _.delay ->
      _$viewer.removeClass 'on'

      restoreViewerHeight()
      detachExpandEvent()
      allowDocumentWheelEvent()
    , 300

  setCurrentViewerHeight = (height) ->
    _currentViewerHeight = height

  whenWordSearched = $$message.createListenerToExtension 'B:wordSearched'
  whenOutsideClicked = $$message.createListenerToExtension 'B:outsideClicked'
  whenViewerRendered = $$message.createListenerToExtension 'B:viewerRendered'

  #--------------------
  # Main Tasks
  #--------------------
  createViewer()

  whenWordSearched showViewer
  whenOutsideClicked hideViewer
  whenViewerRendered setCurrentViewerHeight