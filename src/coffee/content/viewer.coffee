###
사전 뷰어

스크립트가 실행되면 `<iframe>` 태그를 생성해 `<html>` 엘리먼트를 추가한다.
페이지 라이프 사이클에서 싱글턴으로 존재한다.
###
class Viewer
  constructor: ->
    @iframe = $('<iframe>')

    @iframe.attr
      id: '__nendic__'
      src: chrome.extension.getURL 'viewer.html'

    @iframe.appendTo(document.documentElement)

new Viewer