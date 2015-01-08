###
캐시를 위한 유틸리티
###
@define 'cache', ->
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

    getLastKey: ->
      _.last(@keys)

    getLast: ->
      @get @getLastKey()

  @exports =
    create: (options) ->
      new Cache options