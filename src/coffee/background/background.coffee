###
각 프레임과의 메시지 수신을 담당한다.
###
@define 'background', ($$message, $$wordSearcher) ->
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
    $$wordSearcher.searchWord(word, sendWordSearched)
  whenDicTypeToggled (isEE) ->
    $$wordSearcher.toggleDicType(isEE, sendWordSearched)

  whenViewerInitialized ->
    $$wordSearcher.searchWordWithRecentQuery(sendWordSearched)

  whenQuerySubmitted (word) ->
    $$wordSearcher.searchWord(word, sendWordSearchedToPopup)  
  whenDicTypeToggledOnPopup (isEE) ->
    $$wordSearcher.toggleDicType(isEE, sendWordSearchedToPopup)