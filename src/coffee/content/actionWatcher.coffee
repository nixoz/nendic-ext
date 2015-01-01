###
각 프레임에서 마우스, 키보드 액션을 관찰하고, 이벤트 발생 시 적합한 작업을 수행한다.
###

#--------------------
# Functions
#--------------------
onDocument = (eventType, handler) ->
  $(document).on eventType, handler

# 스크립트가 로드될 때, 단어 호출 옵션을 가져온다.
_isOptionMatched = null
(->
  $$options.get().then (options) ->
    triggerOption = _.find $$options.TRIGGER_METHODS, (option) ->
      option.value is options.triggerMethod

    _isOptionMatched = triggerOption.handler if triggerOption
)()

# mouse up 시점에 선택된 단어를 보고 처리한다.
# 연속해서 마우스를 클릭하는 경우를 대비해 debounce를 준다.
onMouseUp = _.debounce(_.partial(onDocument, 'mouseup'), 200)
# mouse down 시점에 창을 닫는다.
# 최초 클릭 시 창을 닫고, 이후의 연속적인 액션은 무시한다.
onMouseDown = _.debounce(_.partial(onDocument, 'mousedown'), 200, true)

sendWordSelected = $$message.createSenderToExtension 'T:wordSelected'
sendOutsideClicked = $$message.createSenderToExtension 'T:outsideClicked'

isTextableElement = (e) ->
  /(input|textarea)/i.test(e.target.tagName)

getSelectedText = ->
  window.getSelection().toString().trim()

isAlphabetic = (str) ->
  /^[a-z. -]+$/i.test str

underThreeWords = (str) ->
  str.match(/\S+/g).length <= 3

isValidWord = $$f.validator(isAlphabetic, underThreeWords)

#--------------------
# Main Tasks
#--------------------
onMouseUp (e) ->
  # 트리거 옵션을 불러온 후에만 동작하며, 일반 엘리먼트에서만 수행한다.
  if _.isFunction(_isOptionMatched) and _isOptionMatched(e) and !isTextableElement(e)
    # fix: 선택된 단어 위에서 마우스 클릭 시, 선택 해제되었는데도 단어가 선택된 것처럼 되는 경우가 있다.
    # 다음 틱에서 수행하는 방법으로 우회한다.
    _.defer ->
      selectionText = getSelectedText()
      sendWordSelected selectionText if isValidWord(selectionText)

# 뷰어가 포함되지 않은 프레임에서도 클릭 이벤트가 발생할 수 있으므로,
# 익스텐션에서 이벤트를 받아 모든 프레임으로 보낸다.
onMouseDown () ->
  sendOutsideClicked()