###
각 프레임과의 메시지 수신을 담당한다.
###

#--------------------
# Functions
#--------------------
whenWordSelected = message_.createListenerToTab 'T:wordSelected'
whenOutsideClicked = message_.createListenerToTab 'T:outsideClicked'

sendWordSearched = message_.createSenderToTab 'B:wordSearched'
sendOutsideClicked = message_.createSenderToTab 'B:outsideClicked'

searchWord = (word) ->
  wordSearcher_.searchWord word, (data) ->
    console.log '>>>', data
    sendWordSearched data

#--------------------
# Main Tasks
#--------------------
whenWordSelected searchWord
whenOutsideClicked sendOutsideClicked
