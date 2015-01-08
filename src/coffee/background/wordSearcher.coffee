###
API에 단어를 요청해 검색한다.
###
@define 'wordSearcher', ($$cache, $$cookie, $$constant, $$resultHtmlParser) ->
  # API URL
  # 네이버 영어사전 서비스의 검색 결과에서
  # 본문의 단어를 클릭했을 때 동적으로 뜨는 보조사전 API를 이용한다.
  API_URL = "http://endic.naver.com/searchAssistDict.nhn?query="

  _responseCache = $$cache.create()
  _recentQuery = ''

  # 영영/영한 여부를 쿠키로 설정하기 때문에,
  # 사전 타입 여부를 포함해 캐시 키를 설정한다.
  # @return {Promise}
  createCacheKey = (query) ->
    getDicTypeFromCookie().then (isEE) ->
      "#{query}_#{isEE}"

  # @return {Promise}
  getDicTypeFromCookie = () ->
    $$cookie.get($$constant.DIC_TYPE_COOKIE_NAME).then (value = 'N') ->
      value is 'Y'

  getQueryFromCacheKey = (cacheKey) ->
    _.first(cacheKey.split('_')) if cacheKey

  getIsEeFromCacheKey = (cacheKey) ->
    if cacheKey
      return _.last(cacheKey.split('_')) is 'true'
    false

  # @return {Promise}
  setDicTypeCookie = (isEE) ->
    $$cookie.set($$constant.DIC_TYPE_COOKIE_NAME, if isEE then 'Y' else 'N')

  # 단어를 검색한다.
  # 응답이 캐시에 존재하면 캐시의 것을 사용한다.
  # @param {String} query
  # @param {Function} callback(parsedData) 응답 콜백
  searchWord = (query, callback) ->
    createCacheKey(query).then (cacheKey) ->
      if _responseCache.get(cacheKey)
        _recentQuery = getQueryFromCacheKey(cacheKey)
        return callback _responseCache.get(cacheKey)

      $.ajax
        url: "#{$$constant.API_URL}?query=#{query}"
        # 도메인은 다르지만 익스텐션에서 프록시 역할을 하므로
        # 비동기 요청을 보내도 문제 없다.
        crossDomain: false
        dataType: 'html' # 서버에서 html 형태로 내려준다.
        success: (data) ->
          parsedData = $$resultHtmlParser.parse(data)
          parsedData.query = query
          parsedData.isEE = getIsEeFromCacheKey(cacheKey)

          # 응답을 캐시해둔다
          _responseCache.add cacheKey, parsedData
          _recentQuery = query
          # 데이터에 쿼리를 포함해 응답한다.
          callback parsedData

  @exports =
    # 단어를 검색한다.
    # @param {string} query
    # @param {Function} callback(parsedData)
    searchWord: (query, callback) ->
      searchWord query, callback
    
    # 최근 검색했던 단어로 검색한다.
    # @param {Function} callback(parsedData)
    searchWordWithRecentQuery: (callback) ->
      searchWord(_recentQuery, callback)

    toggleDicType: (isEE, callback) ->
      setDicTypeCookie(isEE).then =>
        @searchWordWithRecentQuery callback