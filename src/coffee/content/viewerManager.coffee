###
사전을 보여줄 iframe을 생성하고, iframe의 on/off를 담당한다.
페이지가 시작될 때 최상위 프레임에 추가한다.
###

#--------------------
# Functions
#--------------------
_$viewer = null

createViewer = ->
  _$viewer = $('<iframe>')
    .attr
      id: '__nendic__'
      src: chrome.extension.getURL 'viewer.html'
    .appendTo document.documentElement

showViewer = ->
  _$viewer.addClass 'on'

whenWordSearched = _.partial message.listenToExtension, 'B:wordSearched'

#--------------------
# Main Tasks
#--------------------
createViewer()
whenWordSearched showViewer