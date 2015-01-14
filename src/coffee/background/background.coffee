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
  whenShortcutPressed = $$message.createListenerToTab 'T:shortcutPressed'

  whenDicTypeToggledOnPopup = $$message.createListenerToPopup 'P:dicTypeToggled'
  whenQuerySubmitted = $$message.createListenerToPopup 'P:querySubmitted'

  sendWordSearched = $$message.createSenderToTab 'B:wordSearched'
  sendOutsideClicked = $$message.createSenderToTab 'B:outsideClicked'
  sendViewerRendered = $$message.createSenderToTab 'B:viewerRendered'
  sendShortcutPressed = $$message.createSenderToTab 'B:shortcutPressed'

  sendWordSearchedToPopup = $$message.createSenderToPopup 'P:wordSearched'

  #--------------------
  # Main Tasks
  #--------------------
  whenViewerRendered sendViewerRendered
  whenOutsideClicked sendOutsideClicked
  whenShortcutPressed sendShortcutPressed

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

  # 컨텍스트 메뉴에 영어사전 검색을 추가한다.
  chrome.contextMenus.create
    title: "네이버 영어사전에서 '%s' 검색"
    contexts: ["selection"]
    onclick: (info) ->
      $$wordSearcher.searchWord(info.selectionText, sendWordSearched)