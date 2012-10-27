/**
 * 백그라운드 모듈에서 사용하는 유틸리티 모듈
 * 
 * @module util
 * @author ohgyun@gmail.com
 * @version 2012.10.27
 */
define([], function () {

  return {
    
    /**
     * 부모 엘리먼트에서 셀렉터에 해당하는 엘리먼트를 찾은 후,
     * 타입에 해당하는 값을 가져온다.
     *
     * @param {$element} parent 부모 엘리먼트
     * @param {string} selector 셀렉터
     * @param {string} type 검색할 타입
     *    text: 해당 DOM의 텍스트를 가져온다.
     *    href: href 값에 영어사전 주소를 붙여 가져온다.
     *    기본값: 속성을 가져온다.
     */ 
    find: function (parent, selector, type) {
      var target = selector ? parent.find(selector) : parent,
        host = 'http://endic.naver.com';
      
      switch (type) {
      
      case 'text':
        return target.text().trim();
        
      case 'href':
        var href = target.attr('href') || '';
        if (href) {
          href = host + href; 
        }
        return href;
        
      default:
        var attr = target.attr(type) || '';
        return attr;

      }
    }
    
  };
  
});
