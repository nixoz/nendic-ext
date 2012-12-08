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
  
  var _$doc = $(document), 
    viewer; // 뷰어는 프레임이 활성화된 경우에 로드되며,
              // 로드되었을 때에 변수에 할당한다.


  // 프레임에 마우스액션이 감지되었을 때
  // 프레임 활성화를 위한 메시지를 보낸다.
  // 이 메시지는 최초 한 번만 보낸다.
  _$doc.one('mousedown', function (e) {
    pubsub.pub('@-frame-observed', {
      frameId: frameObserver.getFrameId()
    });
  });
  
  // 뷰어가 아닌 영역을 클릭한 경우, 뷰어를 닫는다. 
  _$doc.mousedown(function (e) {
    if ( ! (viewer && viewer.hasElement(e.target))) {
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

  // 뷰어 바깥 영역에 마우스 이벤트가 발생한 경우
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
      loadViewer(function () {
        viewer.open(data);
      });      
    }
  });

  // 뷰어를 로드하고 로드가 완료되면 콜백을 실행한다.
  function loadViewer(callback) {
    if (viewer) {
      callback();
      return;
    }

    require(['cscript/viewer/viewer'], function (v) {
      viewer = v;
      bindViewerEventHandler();
      pubsub.pub('@-viewer-activated');
      callback();
    });
  }
  
  // 뷰어에 이벤트 핸들러를 설정한다. 
  // 뷰어가 로드된 이후에 붙인다.
  function bindViewerEventHandler() {
    // 한/영 전환     
    viewer.onAction('toggleDicType', function () {
      pubsub.pub('@-dic-type-toggle-btn-clicked');
    });
  }

  // 탭이 업데이트 된 경우
  // 뷰어 활성화 여부에 대한 메시지를 던져준다.
  pubsub.sub('*-tab-updated', function () {
    if (viewer) {
      pubsub.pub('@-viewer-activated');
    } else {
      pubsub.pub('@-viewer-inactivated');
    }
  });  

  // 익스텐션 아이콘을 클릭한 경우
  pubsub.sub('*-extension-icon-clicked', function () {
    // 이 메시지는 뷰어가 활성화되어 있는 경우에만 전달된다.
    viewer.open();
  });

});
