###
사전이 렌더링되는 페이지의 스크립트
###

#--------------------
# Functions
#--------------------
whenWordSearched = message_.createListenerToExtension 'B:wordSearched'

#--------------------
# Main Tasks
#--------------------
angular.module('viewerApp', [])
  .controller 'mainCtrl', ($scope) ->
    $scope.query = ''
    $scope.result = []

    whenWordSearched (data) =>
      $scope.query = data.query
      $scope.result = data.result
      # angular 범위 밖에서 호출된 것이기 때문에 apply()를 호출해줘야 한다.
      $scope.$apply()
