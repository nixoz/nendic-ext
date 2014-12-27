###
각 프레임에서 마우스, 키보드 액션을 관찰하고, 이벤트 발생 시 적합한 작업을 수행한다.
###

#--------------------
# Functions
#--------------------
onDocument = (eventType, handler) ->
  $(document).on eventType, handler

onDoubleClick = _.partial onDocument, 'dblclick'
onMouseDown = _.partial onDocument, 'mousedown'

sendWordSelected = message.sendToExtension 'T:wordSelected'
sendOutsideClicked = message.sendToExtension 'T:outsideClicked'

isTextableElement = (e) ->
  /(input|textarea)/i.test(e.target.tagName)

getSelectedText = ->
  window.getSelection().toString().trim()

#--------------------
# Main Tasks
#--------------------
onDoubleClick (e) ->
  unless isTextableElement(e)
    selectionText = getSelectedText()
    sendWordSelected selectionText if selectionText

# 뷰어가 포함되지 않은 프레임에서도 클릭 이벤트가 발생할 수 있으므로,
# 익스텐션에서 이벤트를 받아 모든 프레임으로 보낸다.
onMouseDown (e) ->
  sendOutsideClicked()