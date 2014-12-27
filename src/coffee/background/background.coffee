###
각 프레임과의 메시지 수신을 담당한다.
###

console.log 'v3 background'


listenToContent = (handler) ->
	chrome.runtime.onMessage.addListener (data, sender) ->
		handler(data) if sender.tab

listenToContent (data) ->
	console.log 'received --->', data

