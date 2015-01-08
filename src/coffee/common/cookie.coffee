@define 'cookie', ($$constant) ->
  @exports =
    # @return {Promise}
    get: (name) ->
      deferred = Q.defer()

      chrome.cookies.get
        url: $$constant.API_URL
        name: name
      , (cookie) ->
        cookieValue = (cookie and cookie.value) or null
        deferred.resolve cookieValue

      deferred.promise

    # @return {Promise}
    set: (name, value) ->
      deferred = Q.defer()

      # fix: Mac OS에서 쿠키가 삭제되지 않고 append 되는 문제가 있어
      # 명시적으로 삭제 후 다시 설정한다.
      chrome.cookies.remove
        url: $$constant.API_URL
        name: name
      , ->
        chrome.cookies.set
          url: $$constant.API_URL
          name: name
          value: value
        , (cookie) ->
          deferred.resolve()

      deferred.promise