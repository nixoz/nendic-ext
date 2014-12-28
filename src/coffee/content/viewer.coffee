###
사전이 렌더링되는 페이지의 스크립트
###

#--------------------
# Functions
#--------------------
whenWordSearched = message_.createListenerToExtension 'B:wordSearched'

renderDictionary = (data) ->
	console.log('>>>>>>', data)
	$('#result').html(_.escape(data))

#--------------------
# Main Tasks
#--------------------
whenWordSearched renderDictionary