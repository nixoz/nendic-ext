###
영어사전 익스텐션의 옵션
###
@define 'options', ($$storage) ->
  # @return {Promise}
  TRIGGER_METHODS = (->
    isMac = navigator.platform is 'MacIntel'
    ctrlKeyName = if isMac then '<Cmd>' else '<Ctrl>'
    altKeyName = '<Alt>'
    mouseMethodDesc = '<더블클릭 또는 마우스로 드래그>'
    
    [
      {
        value: 'mouse', desc: "#{mouseMethodDesc}",
        handler: (e) -> true
      }
      {
        value: 'ctrl_mouse', desc: "#{ctrlKeyName} + #{mouseMethodDesc}",
        handler: (e) -> if isMac then e.metaKey else e.ctrlKey
      }
      {
        value: 'alt_mouse', desc: "#{altKeyName} + #{mouseMethodDesc}",
        handler: (e) -> e.altKey
      }
    ]
  )()

  DEFAULT_OPTIONS =
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

