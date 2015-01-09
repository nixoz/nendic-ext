###
옵션 페이지
###
@define 'optionPage', ($$constant, $$message, $$options, $$notice, $$newBadge) ->
  sendWordSelected = $$message.createSenderToExtension 'T:wordSelected'
  
  #--------------------
  # Main Tasks
  #--------------------
  angular.module('optionsApp', [])

    .controller 'mainCtrl', ($scope) ->
      $scope.menu = 'option'

    .controller 'optionCtrl', ($scope) ->
      $scope.TRIGGER_METHODS = $$options.TRIGGER_METHODS
      $scope.options = {}
      $scope.isChanged = false

      reloadViewer = ->
        # 새 설정을 적용할 때부터는 캐시된 값을 가져와 렌더링한다.
        $('#viewer').attr('src', 'viewer.html?init=true')

      showUpdated = ->
        $scope.isChanged = true
        $scope.$apply()

      $scope.save = ->
        $$options.set($scope.options).then ->
          showUpdated()

      $scope.setSmaller = ->
        $scope.options.fontSize -= 5 if $scope.options.fontSize > 60
        reloadViewer()
        $scope.save()

      $scope.setLarger = ->
        $scope.options.fontSize += 5 if $scope.options.fontSize < 140
        reloadViewer()
        $scope.save()

      # 앱이 시작되면 옵션을 불러온다
      $$options.get().then (options) ->
        $scope.options = options
        $scope.$apply()
        # 옵션 페이지 로드 후, 폰트 사이즈의 샘플 페이지를 보여주기 위해 `example`로 검색을 수행한다.
        sendWordSelected 'example'

    .controller 'feedbackCtrl', ($scope) ->
      $('#todo').attr('src', $$constant.TODO_DOC_URL)
      $scope.bugUrl = $$constant.BUG_DOC_URL
      $scope.feedbackUrl = $$constant.FEEDBACK_DOC_URL
      $scope.notice = $$notice.getCurrentVersionNotice()

      # 업데이트 뱃지를 제거한다.
      $$newBadge.updateToCurrentVersion()
