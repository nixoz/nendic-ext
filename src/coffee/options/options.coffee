###
옵션 페이지
###

#--------------------
# Main Tasks
#--------------------
angular.module('optionsApp', [])
  .controller 'mainCtrl', ($scope) ->
    $scope.TRIGGER_METHODS = $$options.TRIGGER_METHODS
    $scope.options = {}
    $scope.isChanged = false

    showUpdated = ->
      $scope.isChanged = true
      $scope.$apply()

    $scope.save = ->
      $$options.set($scope.options).then ->
        showUpdated()

    $$options.get().then (options) ->
      $scope.options = options
      $scope.$apply()



