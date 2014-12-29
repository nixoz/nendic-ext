###
캐시를 위한 유틸리티
###
class Cache
  constructor: (maxSize = 30) ->
    @maxSize = maxSize
    @map = {}
    @keys = []

  add: (key, val) ->
    unless _.contains(@keys, key)
      @keys.push key
    @map[key] = val

    if @keys.length > @maxSize
      firstKey = @keys.shift()
      delete @map[firstKey]

  get: (key) ->
    @map[key]

  getLast: ->
    lastKey = _.last(@keys)
    @get lastKey

@cache_ =
  create: (options) ->
    new Cache options