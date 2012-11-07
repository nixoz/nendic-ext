/**
 * API에 단어를 요청해 검색하는 모듈
 *
 * @module wordSearcher
 * @author ohgyun@gmail.com
 * @version 2012.10.27
 */
define([

  'jquery',
  'bg/parser/resultHtmlParser'
  
], function ($, resultHtmlParser) {
  
  var
    // API URL
    // 네이버 영어사전 서비스의 검색 결과에서
    // 본문의 단어를 클릭했을 때 동적으로 뜨는 보조사전 API를 이용한다.
    API_URL = 'http://endic.naver.com/searchAssistDict.nhn?query=',
  
    // 최근 검색한 단어
    // 재검색하거나 한/영 단어 전환 시 사용한다.
    _recentQuery = '';
 
  /**
   * 단어를 검색한다.
   * @param {string} query
   */
  function searchWord(query, callback) {
    cacheRecentQuery(query);
    requestQuery(query, callback);
  }
  
  /**
   * 최근 검색어를 캐시해둔다.
   * @param {string} query
   */
  function cacheRecentQuery(query) {
    _recentQuery = query;
  }
  
  /**
   * 단어를 ajax로 요청해 가져온다.
   *
   * @param {string} query
   * @param {function (parsedData)} callback 응답 콜백
   */
  function requestQuery(query, callback) {
    var url = API_URL + query;
    
    $.ajax({
      url: url,
      // 도메인은 다르지만 익스텐션에서 프록시 역할을 하므로
      // 비동기 요청을 보내도 문제 없다.
      crossDomain: false,
      dataType: 'html', // 영어사전 
      success: function (data) {
        response(data, query, callback);
      }
    });    
  }

  /**
   * 결과에 대한 응답을 보낸다.
   * @param {?object} data
   * @param {string} query
   * @param {function (parsedData)} callback 응답 콜백
   */
  function response(data, query, callback) {
    var parsedData = resultHtmlParser.parse(data);
    
    // 데이터에 쿼리를 포함해 응답한다.
    parsedData.query = query;
    
    callback(parsedData);
  }
  
  return {
    
    /**
     * 단어를 검색한다.
     * @param {string} query
     * @param {function (parsedData)} callback
     */
    searchWord: function (query, callback) {
      searchWord(query, callback);
    },
    
    /**
     * 최근 검색했던 단어로 검색한다.
     * @param {function (parsedData)} callback
     */
    searchWordWithRecentQuery: function (callback) {
      searchWord(_recentQuery, callback);
    }
    
  };
  
});
