###
각 프레임과의 메시지 수신을 담당한다.
###

#--------------------
# Functions
#--------------------
whenWordSelected = message_.createListenerToTab 'T:wordSelected'
whenOutsideClicked = message_.createListenerToTab 'T:outsideClicked'
whenViewerInitialized = message_.createListenerToTab 'T:viewerInitialized'
whenViewerRendered = message_.createListenerToTab 'T:viewerRendered'

sendWordSearched = message_.createSenderToTab 'B:wordSearched'
sendOutsideClicked = message_.createSenderToTab 'B:outsideClicked'
sendViewerRendered = message_.createSenderToTab 'B:viewerRendered'

searchWord = (word) ->
  wordSearcher_.searchWord(word, sendWordSearched)

searchWordWithRecentQuery = () ->
  wordSearcher_.searchWordWithRecentQuery(sendWordSearched)

#--------------------
# Main Tasks
#--------------------
whenWordSelected searchWord
whenViewerInitialized searchWordWithRecentQuery
whenViewerRendered sendViewerRendered
whenOutsideClicked sendOutsideClicked