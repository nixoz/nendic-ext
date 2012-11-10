/**
 * 백그라운드 작업의 메인 모듈
 * 
 * @author ohgyun@gmail.com
 * @version 2012.10.27
 */
require([
  
  'common/pubsub',
  'bg/wordSearcher',
  'bg/frameManager',
  'bg/dicTypeToggler'
  
], function (pubsub, wordSearcher, frameManager, dicTypeToggler) {

  // 메시지 규칙
  // 1. 완료형으로만 보낸다.
  // 2. 소문자와 대시(-)를 사용한다.
  // 3. 컨텐트 스크립트에서 보낸 경우, 앞에 @- 를 붙인다.
  // 4. 백그라운드에서 보낸 경우, 앞에 *- 를 붙인다.

  // 컨텍스트 메뉴에 영어사전 검색을 추가한다.
  chrome.contextMenus.create({
    "title": "네이버 영어사전에서 '%s' 검색",
    "contexts": ["selection"],
    "onclick": function (info) {
      wordSearcher.searchWord(info.selectionText, function (data) {
        pubsub.pub('*-word-searched', data);
      });
    }
  });
  
  // 뷰어 바깥 영역이 클릭된 경우
  pubsub.sub('@-outofviewer-clicked', function () {
    // 뷰어가 아닌 영역을 클릭한 경우,
    // 뷰어를 닫아줘야 한다.
    // 프레임이 여러 개인 경우에도 닫아줘야 하므로,
    // 익스텐션에서 메시지를 받아 모든 프레임이 전달한다.
    pubsub.pub('*-outofviewer-clicked');
  });

  // 검색할 단어가 선택된 경우
  pubsub.sub('@-word-selected', function (data) {
    wordSearcher.searchWord(data.query, function (data) {
      pubsub.pub('*-word-searched', data);
    });
  });

  // 프레임에 유저 액션이 발생한 경우
  pubsub.sub('@-frame-observed', function (data) {
    // 프레임이 존재하는지 검사하고,
    frameManager.checkFrameExist(data, function () {
      // 프레임이 존재하지 않을 경우,
      // 프레임을 리셋하고 메시지를 보낸다.
      pubsub.pub('*-frame-repos-reseted'); 
    });
  });

  // 프레임 정보가 수집된 경우
  pubsub.sub('@-frame-info-collected', function (data) {
    // 받아온 프레임 정보를 매니저에 등록한다.
    frameManager.registerAndActivateFrame(data, function (frameId) {
      pubsub.pub('*-frame-newly-activated', {
        frameId: frameId
      });
    });
  });

  // 영/한 사전 토글 시
  pubsub.sub('@-dic-type-toggle-btn-clicked', function (data) {
    dicTypeToggler.toggle(function () {
      wordSearcher.searchWordWithRecentQuery(function (data) {
        pubsub.pub('*-word-searched', data);
      });
    });
  });
  
});
