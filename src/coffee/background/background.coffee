###
각 프레임과의 메시지 수신을 담당한다.
###

#--------------------
# Functions
#--------------------
whenWordSelected = $$message.createListenerToTab 'T:wordSelected'
whenOutsideClicked = $$message.createListenerToTab 'T:outsideClicked'
whenViewerInitialized = $$message.createListenerToTab 'T:viewerInitialized'
whenViewerRendered = $$message.createListenerToTab 'T:viewerRendered'
whenDicTypeToggled = $$message.createListenerToTab 'T:dicTypeToggled'

whenDicTypeToggledOnPopup = $$message.createListenerToPopup 'P:dicTypeToggled'
whenQuerySubmitted = $$message.createListenerToPopup 'P:querySubmitted'

sendWordSearched = $$message.createSenderToTab 'B:wordSearched'
sendOutsideClicked = $$message.createSenderToTab 'B:outsideClicked'
sendViewerRendered = $$message.createSenderToTab 'B:viewerRendered'

sendWordSearchedToPopup = $$message.createSenderToPopup 'P:wordSearched'

#--------------------
# Main Tasks
#--------------------
whenViewerRendered sendViewerRendered
whenOutsideClicked sendOutsideClicked

whenWordSelected (word) ->
  wordSearcher_.searchWord(word, sendWordSearched)
whenDicTypeToggled (isEE) ->
  wordSearcher_.toggleDicType(isEE, sendWordSearched)

whenViewerInitialized ->
  wordSearcher_.searchWordWithRecentQuery(sendWordSearched)

whenQuerySubmitted (word) ->
  wordSearcher_.searchWord(word, sendWordSearchedToPopup)  
whenDicTypeToggledOnPopup (isEE) ->
  wordSearcher_.toggleDicType(isEE, sendWordSearchedToPopup)