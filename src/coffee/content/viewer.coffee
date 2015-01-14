###
사전이 렌더링되는 페이지의 스크립트
###
@define 'viewer', ($$message, $$options, $$analytics) ->
  #--------------------
  # Functions
  #--------------------
  whenWordSearched = $$message.createListenerToExtension 'B:wordSearched'
  whenShortcutPressed = $$message.createListenerToExtension 'B:shortcutPressed'
  whenWordSearchedFromPopup = $$message.createListenerToWindow 'P:wordSearched'

  sendViewerInitialized = $$message.createSenderToExtension 'T:viewerInitialized'
  # 뷰가 렌더링 되었다고 알린다. iframe의 사이즈를 지정하는데 사용된다.
  # @param {Number} height
  sendViewerRenderered = $$message.createSenderToExtension 'T:viewerRendered'
  sendViewerRendereredToWindow = $$message.createSenderToWindow(window.top, 'T:viewerRendered')
  sendDicTypeToggled = $$message.createSenderToExtension 'T:dicTypeToggled'
  # 팝업에서 iframe으로 뷰어가 열리는 경우, 백그라운드에서 팝업에 있는 iframe에 메시지를 보낼 수 없다.
  # 팝업과는 윈도우 메시지로 통신하고, 팝업의 결과를 다시 받아 렌더링하는 방식으로 처리한다.
  sendDicTypeToggledToWindow = $$message.createSenderToWindow(window.top, 'T:dicTypeToggled')

  # 옵션을 불러온다.
  $$options.get().then (options) ->
    $('.wrap').css('font-size', "#{options.fontSize}%")

  # 단축키를 선택했을 때의 액션
  # 구현의 단순화를 위해 엘리먼트를 찾아 클릭하는 방법으로 처리한다.
  shortcutActions =
    'g': ->
      # jQuery의 클릭은 물리적인 클릭과는 동일하지 않다.
      # 물리적인 클릭을 발생하기 위해 엘리먼트의 클릭 메서드를 활용한다.
      $('._title')[0]?.click()
    'a': ->
      $('._audioBtn').click() 
    's': ->
      $('._toggleBtn').click()

  #--------------------
  # Main Tasks
  #--------------------
  angular.module('viewerApp', [])
    .config ($locationProvider) ->
      $locationProvider.html5Mode
        enabled: true
        requireBase: false

    .controller 'mainCtrl', ($scope, $location) ->
      $scope.query = ''
      $scope.result = []
      $scope.isPlayingAudio = false
      $scope.isEE = false # 영영사전인지 여부

      $scope.playAudio = (playUrl) ->
        return if $scope.isPlayingAudio

        $scope.isPlayingAudio = true
        $audio = $('<audio>').attr('src', playUrl)
        
        # 오디오 재생에 따른 이벤트
        # 한 번만 실행하고 삭제한다.
        $audio.one
          ended: ->
            $scope.isPlayingAudio = false
            $scope.$apply()
            $audio[0].pause() # 재생이 종료되면 pause 상태로 만든다.
            $audio.remove()

        $audio[0].play()

      $scope.toggleDicType = ->
        sendDicTypeToggled(!$scope.isEE)
        sendDicTypeToggledToWindow(!$scope.isEE)

      renderViewer = (data) ->
        $scope.query = data.query
        $scope.result = data.result
        $scope.isEE = data.isEE
        # angular 범위 밖에서 호출된 것이기 때문에 apply()를 호출해줘야 한다.
        $scope.$apply()

        # 쿼리가 있을 경우, 페이지 렌더링 결과를 보낸다.
        # `query` 파라미터는 애널리틱스에서 검색어 파악을 위해 사용한다.
        if data.query
          $$analytics.trackPage "viewer.html?query=#{data.query.replace(/\s/g, '+')}"

        window.scrollTo(0, 0); # 같은 윈도우를 재활용하므로 렌더링 이후에 스크롤을 초기화한다
        sendViewerRenderered document.documentElement.scrollHeight
        sendViewerRendereredToWindow document.documentElement.scrollHeight

      # viewer.html은 처음 사전을 검색했을 때, 문서에 추가되면서 로드된다.
      # 페이지가 시작할 때 iframe을 만들어두면 되긴 하지만, 사전 검색이 필요없는 페이지라면 비효율적이다.
      # 검색이 일어날 때 뷰를 추가하면, 검색 결과보다 뷰가 더 늦게 로드되기 때문에 초기엔 데이터가 없다.
      # 뷰는 초기화되었음을 알리고, 백그라운드에선 기존 결과를 다시 보내주는 방식으로 우회한다.
      # 이 옵션은 파라미터로 `init=true` 를 전달했을 떄에만 처리한다.
      if $location.search().init is 'true'
        sendViewerInitialized()

      whenWordSearched (data) ->
        renderViewer data
      whenWordSearchedFromPopup (data) ->
        renderViewer data
      whenShortcutPressed (key) ->
        shortcutActions[key]?()

