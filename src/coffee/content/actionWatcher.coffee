###
각 프레임에서 마우스, 키보드 액션을 관찰하고, 이벤트 발생 시 적합한 작업을 수행한다.
###
sendToExtension = (msg) ->
  chrome.runtime.sendMessage(msg)

onDocument = (eventType, handler) ->
  $(document).on eventType, handler

onDocumentDoubleClick = _.partial onDocument, 'dblclick'


# Main Tasks
onDocumentDoubleClick (e) ->
  console.log 'dblclicked!!!'
  sendToExtension 'hello extension'

