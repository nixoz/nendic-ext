###
브라우저에 액션에 의해 노출되는 팝업 페이지
###

#--------------------
# Functions
#--------------------
# whenWordSearched = message_.createListenerToExtension 'B:wordSearched'

# sendViewerInitialized = message_.createSenderToExtension 'T:viewerInitialized'
# # 뷰가 렌더링 되었다고 알린다. iframe의 사이즈를 지정하는데 사용된다.
# # @param {Number} height
# sendViewerRenderered = message_.createSenderToExtension 'T:viewerRendered'
# sendDicTypeToggled = message_.createSenderToExtension 'T:dicTypeToggled'


#--------------------
# Main Tasks
#--------------------
angular.module('popupApp', [])
  .controller 'mainCtrl', ($scope) ->
    console.log '짠~~'
