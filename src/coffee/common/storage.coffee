###
크롬 익스텐션의 로컬 스토리지
###
@$$storage =
  # @return {Promise}
  set: (key, value) ->
    deferred = Q.defer()
    items = {}
    items[key] = value
    chrome.storage.local.set items, ->
      deferred.resolve()
    deferred.promise

  # @return {Promise}
  get: (key) ->
    deferred = Q.defer()
    chrome.storage.local.get key, (items) ->
      deferred.resolve items[key]
    deferred.promise