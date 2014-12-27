###
각 프레임과의 메시지 수신을 담당한다.
###

#--------------------
# Functions
#--------------------
whenWordSelected = _.partial message.listenToTab, 'T:wordSelected'
sendWordSearchedToTab = _.partial message.sendToTab, 'B:wordSearched'

searchWord = (word) ->
	console.log 'searching...', word
	sendWordSearchedToTab "SEARCHED: #{word}"


#--------------------
# Main Tasks
#--------------------
whenWordSelected searchWord
