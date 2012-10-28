/**
 * 컨텐트 스크립트의 메인 모듈
 * 
 * @author ohgyun@gmail.com
 * @version 2012.10.27
 */
require([
  
  'jquery',
  'common/pubsub',
  'cscript/frameObserver'
  
], function ($, pubsub, frameObserver) {
  
  console.log('cscri3pt_main');
 
  // 프레임 관찰자 
  //--------------

  // 프레임 관찰자에 핸들러를 등록한다.
  frameObserver.onObserve(function (frameId) {
    console.log('frameId: ', frameId);
    pubsub.pub('frame-observed', {
      frameId: frameId
    });
  });

  // 프레임 매니저의 리파지터리가 초기화된 경우,
  // 현재 프레임 정보를 수집해 전송한다. 
  pubsub.sub('frame-repos-reseted', function () {
    var frameInfo = frameObserver.getInfo();
    pubsub.pub('frame-info-collected', frameInfo);
  });

  // 활성화할 프레임을 찾았다는 정보를 받은 경우,
  // 해당 정보로 프레임을 활성화/비활성화한다.
  pubsub.sub('frame-newly-activated', function (data) {
    frameObserver.activate(data.frameId);  
  });


  // 사전 뷰어
  //----------

  // 단어 검색이 완료된 경우
  pubsub.sub('word-searched', function (data) {
    console.log('검색 완료됨. 뷰어를 띄운다.', data);
  });
  
  
});
