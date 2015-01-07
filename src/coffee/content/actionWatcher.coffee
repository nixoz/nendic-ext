###
각 프레임에서 마우스, 키보드 액션을 관찰하고, 이벤트 발생 시 적합한 작업을 수행한다.
###
@define 'actionWatcher', ($$options, $$message, $$f, $$analytics) ->
  #--------------------
  # Functions
  #--------------------
  onDocument = (eventType, handler) ->
    $(document).on eventType, handler

  # 스크립트가 로드될 때, 단어 호출 옵션을 가져온다.
  _isOptionMatched = null
  _triggerMethod = null
  (->
    $$options.get().then (options) ->
      triggerOption = _.find $$options.TRIGGER_METHODS, (option) ->
        option.value is options.triggerMethod

      _triggerMethod = options.triggerMethod
      _isOptionMatched = triggerOption.handler if triggerOption
  )()

  # mouse up 시점에 선택된 단어를 보고 처리한다.
  # 연속해서 마우스를 클릭하는 경우를 대비해 debounce를 준다.
  # onMouseUp = _.debounce(_.partial(onDocument, 'mouseup'), 200)
  # onDoubleClick = _.debounce(_.partial(onDocument, 'dblclick'), 50)
  # mouse down 시점에 창을 닫는다.
  # 최초 클릭 시 창을 닫고, 이후의 연속적인 액션은 무시한다.
  onMouseDown = _.debounce(_.partial(onDocument, 'mousedown'), 200, true)

  onDoubleClick = _.partial(onDocument, 'dblclick')
  onMouseDown = _.partial(onDocument, 'mousedown')
  onMouseUp = _.partial(onDocument, 'mouseup')

  sendWordSelected = $$message.createSenderToExtension 'T:wordSelected'
  sendOutsideClicked = $$message.createSenderToExtension 'T:outsideClicked'

  isTextableElement = (e) ->
    /(input|textarea)/i.test(e.target.tagName)

  getSelectedText = ->
    window.getSelection().toString().trim()

  isValidCharacter = (str) ->
    /^[0-9a-zㄱ-ㅎ가-힣. -]+$/i.test str

  underThreeWords = (str) ->
    str.match(/\S+/g).length <= 3

  isValidWord = $$f.validator(isValidCharacter, underThreeWords)

  _startX = 0
  _startY = 0
  DRAG_THRESHOLD = 15

  #--------------------
  # Main Tasks
  #--------------------
  
  # 1. 마우스 다운 시 창을 닫는다.
  # 뷰어매니저는 최상위 프레임에 있고 각 프레임 간 도메인이 다를 수 있기 때문에
  # 익스텐션에서 메시지를 받아 전달해 창을 닫도록 한다.
  #
  # 2. 텍스트를 드래그해서 선택할 수 있으므로, 마우스 다운 시 시작점을 설정해둔다.
  onMouseDown (e) ->
    _startX = e.pageX
    _startY = e.pageY
    sendOutsideClicked()

  onMouseUp (e) ->
    diffX = Math.abs(_startX - e.pageX)
    diffY = Math.abs(_startY - e.pageY)

    if diffX >= DRAG_THRESHOLD or diffY >= DRAG_THRESHOLD
      sendWordSelectedToSearch(e, "drag + #{_triggerMethod}")

  onDoubleClick (e) ->
    sendWordSelectedToSearch(e, "dblclick + #{_triggerMethod}")

  sendWordSelectedToSearch = (e, method) ->
    # 트리거 옵션을 불러온 후에만 동작하며, 일반 엘리먼트에서만 수행한다.
    if _.isFunction(_isOptionMatched) and _isOptionMatched(e) and !isTextableElement(e)
      selectionText = getSelectedText()
      if isValidWord(selectionText)
        sendWordSelected selectionText
        $$analytics.track("actionWatcher:trigger:#{method}")