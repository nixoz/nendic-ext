###
사전을 보여줄 iframe을 생성하고, iframe의 on/off를 담당한다.
페이지가 시작될 때 최상위 프레임에 추가한다.
###
$iframe = $('<iframe>')
$iframe.attr
  id: '__nendic__'
  src: chrome.extension.getURL 'viewer.html'

$(window).on 'message', (e) ->
  console.log ':::', e