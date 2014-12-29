###
API에 단어를 요청해 검색한다.
TODO 현재는 네이버 영어사전을 쓰고 있지만, 추후 저작권이 자유로운 다른 사전으로 API를 변경한다.
  API 변경 전까지 임시로 기존 파싱 코드를 그대로 사용한다.
###
  
# API URL
# 네이버 영어사전 서비스의 검색 결과에서
# 본문의 단어를 클릭했을 때 동적으로 뜨는 보조사전 API를 이용한다.
API_URL = "http://endic.naver.com/searchAssistDict.nhn?query="

_responseCache = cache_.create()

# 영영/영한 여부를 쿠키로 설정하기 때문에,
# 사전 타입 여부를 포함해 캐시 키를 설정한다.
# @return {Promise}
createCacheKey = (query) ->
  cookie_.get(constant_.DIC_TYPE_COOKIE_NAME).then (value = 'N') ->
    "#{query}_#{value}"

getQueryFromCacheKey = (cacheKey) ->
  _.first(cacheKey.split('_'))

# 단어를 검색한다.
# 응답이 캐시에 존재하면 캐시의 것을 사용한다.
# @param {String} query
# @param {Function} callback(parsedData) 응답 콜백
searchWord = (query, callback) ->
  createCacheKey(query).then (cacheKey) ->
    if _responseCache.get(cacheKey)
      return callback _responseCache.get(cacheKey)

    $.ajax
      url: "#{constant_.API_URL}?query=#{query}"
      # 도메인은 다르지만 익스텐션에서 프록시 역할을 하므로
      # 비동기 요청을 보내도 문제 없다.
      crossDomain: false
      dataType: 'html' # 서버에서 html 형태로 내려준다.
      success: (data) ->
        parsedData = resultHtmlParser_.parse(data)
        parsedData.query = query

        # 응답을 캐시해둔다
        _responseCache.add cacheKey, parsedData
        # 데이터에 쿼리를 포함해 응답한다.
        callback parsedData

@wordSearcher_ =
  # 단어를 검색한다.
  # @param {string} query
  # @param {Function} callback(parsedData)
  searchWord: (query, callback) ->
    searchWord query, callback
  
  # 최근 검색했던 단어로 검색한다.
  # @param {Function} callback(parsedData)
  searchWordWithRecentQuery: (callback) ->
    searchWord getQueryFromCacheKey(_responseCache.getLastKey()), callback