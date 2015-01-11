###
영어사전 익스텐션의 옵션
###
@define 'options', ($$storage) ->
  # @return {Promise}
  TRIGGER_METHODS = (->
    isMac = navigator.platform is 'MacIntel'
    ctrlKeyName = if isMac then '<Cmd>' else '<Ctrl>'
    altKeyName = '<Alt>'
    useDragDesc = '또는 마우스로 드래그'
    doubleClickDesc = '더블클릭'
    
    [
      {
        value: 'mouse'
        desc: (useDrag) ->
          "<#{doubleClickDesc} #{if useDrag then useDragDesc else ''}>"
        handler: (e) -> true
      }
      {
        value: 'ctrl_mouse'
        desc: (useDrag) ->
          "#{ctrlKeyName} + <#{doubleClickDesc} #{if useDrag then useDragDesc else ''}>"
        handler: (e) -> if isMac then e.metaKey else e.ctrlKey
      }
      {
        value: 'alt_mouse'
        desc: (useDrag) ->
          "#{altKeyName} + <#{doubleClickDesc} #{if useDrag then useDragDesc else ''}>"
        handler: (e) -> e.altKey
      }
    ]
  )()

  DEFAULT_OPTIONS =
    useDrag: false # 드래그 해서 선택할 것인지 여부
    triggerMethod: TRIGGER_METHODS[0].value
    fontSize: 100
    useShortcut: false

  @exports =
    TRIGGER_METHODS: TRIGGER_METHODS
    DEFAULT_OPTIONS: DEFAULT_OPTIONS

    # @return {Promise}
    get: ->
      $$storage.get('options').then (options = {}) =>
        _.defaults options, DEFAULT_OPTIONS

    # @return {Promise}
    set: (options = {}) ->
      $$storage.set('options', options)

