/**
 * 백그라운드 작업의 메인 모듈
 * 
 * @author ohgyun@gmail.com
 * @version 2012.10.27
 */
require([
  
  'common/pubsub',
  'bg/wordSearcher',
  'bg/frameManager'
  
], function (pubsub, wordSearcher, frameManager) {
  console.log('bg_main');
  


  // 단어 검색
  //----------

  // 컨텍스트 메뉴에 영어사전 검색을 추가한다.
  chrome.contextMenus.create({
    "title": "네이버 영어사전에서 '%s' 검색",
    "contexts": ["selection"],
    "onclick": function (info) {
      pubsub.pub('word-selected', {
        word: info.selectionText
      });
    }
  });
  
  // 검색할 단어가 선택된 경우
  pubsub.sub('word-selected', function (data) {
    wordSearcher.searchWord(data, function (data) {
      console.log('word-searched', data);
      pubsub.pub('word-searched', data);
    });
  });


  // 프레임 관리
  //------------

  // 프레임에 유저 액션이 발생한 경우
  pubsub.sub('frame-observed', function (data) {
    console.log('frame-osberved received', data);
    frameManager.checkFrameExist(data, function () {
      // 프레임이 존재하지 않을 경우,
      // 프레임을 리셋하고 메시지를 보낸다.
      pubsub.pub('frame-repos-reseted'); 
    });
  });

  // 프레임 정보가 수집된 경우
  pubsub.sub('frame-info-collected', function (data) {
    console.log('collected', data);
    // 받아온 프레임 정보를 매니저에 등록한다.
    frameManager.registerAndActivateFrame(data, function (frameId) {
      pubsub.pub('frame-newly-activated', {
        frameId: frameId
      });
    });
  });

  
});
