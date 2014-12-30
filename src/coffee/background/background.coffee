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
whenDicTypeToggled = message_.createListenerToTab 'T:dicTypeToggled'

whenDicTypeToggledOnPopup = message_.createListenerToPopup 'P:dicTypeToggled'
whenQuerySubmitted = message_.createListenerToPopup 'P:querySubmitted'

sendWordSearched = message_.createSenderToTab 'B:wordSearched'
sendOutsideClicked = message_.createSenderToTab 'B:outsideClicked'
sendViewerRendered = message_.createSenderToTab 'B:viewerRendered'

sendWordSearchedToPopup = message_.createSenderToPopup 'P:wordSearched'

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