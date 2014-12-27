###
각 프레임에서 마우스, 키보드 액션을 관찰하고, 이벤트 발생 시 적합한 작업을 수행한다.
###

#--------------------
# Functions
#--------------------
onDocument = (eventType, handler) ->
  $(document).on eventType, handler

onDocumentDoubleClick = _.partial onDocument, 'dblclick'

sendWordSelectedToExtension = _.partial message.sendToExtension, 'T:wordSelected'

isTextableElement = (el) ->
  /(input|textarea)/i.test(el.tagName)

getSelectedText = ->
  window.getSelection().toString().trim()

#--------------------
# Main Tasks
#--------------------
onDocumentDoubleClick (e) ->
  unless isTextableElement(e.target)
    selectionText = getSelectedText()
    sendWordSelectedToExtension selectionText if selectionText
