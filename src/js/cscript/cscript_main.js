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
  
], function ($, pubsub) {
  
  console.log('cscri3pt_main');
  
  pubsub.sub('word-searched', function (data) {
    console.log('단어 검색이 완료됐따!', data);
  });
  
  
  pubsub.sub('user-actioned', function (data) {
    
    require([], function () {
      // 필요한 코드는 실제로 사용자 액션이 발생했을 때 로드한다.  
    });
    
  });
  
  
});