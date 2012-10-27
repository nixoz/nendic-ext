/**
 * 백그라운드 작업의 메인 모듈
 * 
 * @author ohgyun@gmail.com
 * @version 2012.10.27
 */
require([
  
  'common/pubsub',
  'bg/wordSearcher'
  
], function (pubsub, wordSearcher) {
  console.log('bg_main');
  
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

  
});