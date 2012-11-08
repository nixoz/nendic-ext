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
  
  // 메시지 규칙
  // 1. 완료형으로만 보낸다.
  // 2. 소문자와 대시(-)를 사용한다.
  // 3. 컨텐트 스크립트에서 보낸 경우, 앞에 @- 를 붙인다.
  // 4. 백그라운드에서 보낸 경우, 앞에 *- 를 붙인다.
  
  var viewer; // 뷰어는 프레임이 활성화된 경우에 로드되며,
              // 로드되었을 때에 변수에 할당한다.


  // 문서에 마우스다운 이벤트 발생 시
  $(document).mousedown(function (e) {
    // 프레임 내에 액션이 관찰되었을 때 메시지를 보낸다.
    pubsub.pub('@-frame-observed', {
      frameId: frameObserver.getFrameId()
    });
    
    if ( ! (viewer && viewer.hasElement(e.target))) {
      // 뷰어가 아닌 영역을 클릭한 경우,
      // 뷰어를 닫아줘야 한다.
      // 뷰어가 포함되지 않은 프레임에서도
      // 클릭 이벤트가 발생할 수 있으므로,
      // 익스텐션에서 이벤트를 받아 모든 프레임으로 보낸다.
      pubsub.pub('@-outofviewer-clicked');
    }
  });

  // 더블 클릭으로 텍스트 선택 시 단어를 검색한다.
  $(document).dblclick(function (e) {
    var target = e.target;

    // input 이나 textarea 인 경우 무시한다.
    if (/(input|textarea)/i.test(target.tagName)) {
      return;
    }
   
    // 현재 선택한 문자열을 가져온다.
    var selectionText = window.getSelection().toString().trim();

    if (selectionText) {
      pubsub.pub('@-word-selected', {
        query: selectionText
      });
    }
  });

  // 현재 프레임 정보를 수집해 전송한다. 
  pubsub.sub('*-frame-repos-reseted', function () {
    var frameInfo = frameObserver.getInfo();
    pubsub.pub('@-frame-info-collected', frameInfo);
  });

  // 활성화할 프레임을 찾았다는 정보를 받은 경우,
  // 해당 정보로 프레임을 활성화/비활성화한다.
  pubsub.sub('*-frame-newly-activated', function (data) {
    frameObserver.activate(data.frameId);  
  });

  // 뷰어 바깐 영역에 마우스 이벤트가 발생한 경우
  pubsub.sub('*-outofviewer-clicked', function () {
    // 뷰어가 존재하는 경우 닫는다.
    if (viewer) {
      viewer.close();
    }
  });

  // 단어 검색이 완료된 경우
  pubsub.sub('*-word-searched', function (data) {
    if (frameObserver.isActivated()) {
      // 프레임이 활성화 된 경우에만 뷰어를 로드한다.
      require(['cscript/viewer/viewer'], function (v) {
        viewer = v;
        viewer.open(data);
      });
    }
  });
  
});
