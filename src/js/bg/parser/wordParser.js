/**
 * 검색 결과의 '단어 제목' 부분을 파싱하는 모듈
 * 
 * @module wordParser
 * @author ohgyun@gmail.com
 * @version 2012.10.27
 */
define([

  'jquery',
  'common/util'
  
], function ($, util) {

  var _$wrapper = null;

  /**
   * 기준 래퍼를 할당한다.
   */
  function setWrapper(elWrapper) {
    _$wrapper = $(elWrapper);
  }

  /**
   * HTML을 파싱한다.
   */
  function parseHtmlToData() {
    var data = {
      // 단어 제목
      'title': util.find(_$wrapper, '.t1 strong', 'text') || util.find(_$wrapper, '.t1 a', 'text'),
      
      // 몇 번째 단어인지
      'number': util.find(_$wrapper, '.t1 sup', 'text'),
      
      // 영어사전 검색 URL
      'url': util.find(_$wrapper, '.t1 a', 'href'),
      
      // 발음 기호
      'phonetic_symbol': util.find(_$wrapper, '.t2', 'text'),
      
      // 영어 발음 재생 URL
      'pronunciation': util.find(_$wrapper, '#pron_en', 'playlist')
    };   
    return data; 
  }
  
  /**
   * DOM을 초기화하고 메모리 해제한다.
   */
  function reset() {
    _$wrapper.remove();
    _$wrapper = null;
  }

  return {
    
    /**
     * 기준 래퍼를 할당한다.
     */
    setWrapper: function (elWrapper) {
      setWrapper(elWrapper);
    },
    
    /**
     * HTML을 파싱한다.
     */
    parse: function () {
      var parsed = parseHtmlToData();
      
      reset();
      
      return parsed;
    }
    
  };

});