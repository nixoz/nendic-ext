###
브라우저에 액션에 의해 노출되는 팝업 페이지
###
@define 'popup', ($$message, $$analytics) ->
  VIEWER_TOP_OFFSET = 46
  VIEWER_MAX_HEIGHT = 400

  #--------------------
  # Functions
  #--------------------
  whenWordSearched = $$message.createListenerToExtension 'P:wordSearched'
  whenDicTypeToggled = $$message.createListenerToWindow 'T:dicTypeToggled'
  whenViewerRendered = $$message.createListenerToWindow 'T:viewerRendered'

  sendQuerySubmitted = $$message.createSenderToExtension 'P:querySubmitted'
  sendWordSearchedToIframe = $$message.createSenderToWindow(
    document.getElementById('viewer').contentWindow, 'P:wordSearched')
  sendDicTypeToggled = $$message.createSenderToExtension 'P:dicTypeToggled'

  #--------------------
  # Main Tasks
  #--------------------
  angular.module('popupApp', [])
    .controller 'mainCtrl', ($scope) ->
      $scope.query = ''

      # css 에서 .viewer-wrap의 display를 none으로 설정하고 있어도,
      # iframe을 포함하고 있어서 팝업창이 크게 늘어났다가 줄어든다.
      # 이를 우회하기 위해, 인라인으로 display를 none 시키고,
      # 검색 시점에 팝업 사이즈를 동적으로 늘려준다.
      # 팝업 사이즈는 html 에 css 를 설정해주는 방식으로 처리할 수 있으며,
      # 팝업의 최대 높이가 있기 때문에 충분히 높은 값을 설정해준다.
      resizePopup = (height) ->
        properHeight = if height > VIEWER_MAX_HEIGHT then VIEWER_MAX_HEIGHT else height
        $('#viewer').height(properHeight)
        $(document.documentElement).css('height', "#{VIEWER_TOP_OFFSET + properHeight}px")
      
      whenWordSearched (data) ->
        sendWordSearchedToIframe data

      whenDicTypeToggled sendDicTypeToggled
      whenViewerRendered resizePopup

      $scope.search = ->
        # 검색어가 없으면 아무 동작을 하지 않는다.
        return unless $scope.query

        # 검색 결과 응답이 오기 전에 iframe을 보이도록 설정한다.
        # 그렇지 않으면, iframe의 scrollHeight가 부모의 scrollHeight를 리턴한다.
        $('.viewer-wrap').show()
        sendQuerySubmitted $scope.query

        $$analytics.trackEvent('popup:search')
      
      $scope.selectQuery = ($event) ->
        $event.target.select() 

      # 페이지가 로드되면 쿼리 엘리먼트에 포커스를 준다.
      $('#query').focus()