###
각 프레임과의 메시지 수신을 담당한다.
###

#--------------------
# Functions
#--------------------
whenWordSelected = message.listenToTab 'T:wordSelected'
whenOutsideClicked = message.listenToTab 'T:outsideClicked'

sendWordSearched = message.sendToTab 'B:wordSearched'
sendOutsideClicked = message.sendToTab 'B:outsideClicked'

searchWord = (word) ->
	console.log 'searching...', word
	sendWordSearched "SEARCHED: #{word}"


#--------------------
# Main Tasks
#--------------------
whenWordSelected searchWord
whenOutsideClicked sendOutsideClicked
