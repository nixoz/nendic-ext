###
각 프레임과의 메시지 수신을 담당한다.
###

#--------------------
# Functions
#--------------------
listenToTab = (name, handler) ->
	chrome.runtime.onMessage.addListener (req, sender) ->
		return unless sender.tab
		handler(req.data) if req.name is name

sendToTab = (name, data) ->
	chrome.tabs.query
		active: true
		currentWindow: true
	, (tabs) ->
		chrome.tabs.sendMessage tabs[0].id,
			name: name
			data: data

onWordSelected = _.partial listenToTab, 'T:wordSelected'

#--------------------
# Main Tasks
#--------------------
onWordSelected (data) ->
	console.log 'received --->', data
	sendToTab 'B:wordSearched', 'foo'

