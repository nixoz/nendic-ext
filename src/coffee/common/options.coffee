###
영어사전 익스텐션의 옵션
###
@define 'options', ($$storage) ->
  isMac = navigator.platform is 'MacIntel'
  ctrlKeyName = if isMac then '<Cmd>' else '<Ctrl>'
  altKeyName = '<Alt>'

  # @return {Promise}
  DBLCLICK_METHODS = [
    {
      value: 'dblclick'
      desc: "<더블클릭>"
      handler: (e) -> true
    }
    {
      value: 'ctrl_dblclick'
      desc: "#{ctrlKeyName} + <더블클릭>"
      handler: (e) -> if isMac then e.metaKey else e.ctrlKey
    }
    {
      value: 'alt_dblclick'
      desc: "#{altKeyName} + <더블클릭>"
      handler: (e) -> e.altKey
    }
  ]

  DRAG_METHODS = [
    {
      value: 'drag'
      desc: "<드래그>"
      handler: (e) -> true
    }
    {
      value: 'ctrl_drag'
      desc: "#{ctrlKeyName} + <드래그>"
      handler: (e) -> if isMac then e.metaKey else e.ctrlKey
    }
    {
      value: 'alt_drag'
      desc: "#{altKeyName} + <드래그>"
      handler: (e) ->
        e.altKey
    }
  ]

  SHORTCUTS =
    'a': '발음 듣기'
    's': '영한/영영 전환'
    'g': '영어사전 페이지로 이동'

  DEFAULT_OPTIONS =
    useDrag: false # 드래그 해서 선택할 것인지 여부
    dblclickMethod: DBLCLICK_METHODS[0].value
    dragMethod: DRAG_METHODS[0].value
    fontSize: 100
    useShortcut: false

  # 3.0.3 버전까진 드래그와 더블클릭 옵션을 동시에 사용했다.
  # 신규 옵션이 없는 경우, 옵션을 마이그레이션한다.
  #   - 3.0.3 이전: triggerMethod
  #   - 3.0.4 이후: dblclickMethod
  migrateTriggerOption = (options) ->
    # 이미 업데이트 된 경우 패스한다.
    return if options.dblclickMethod and options.dragMethod

    switch (options.triggerMethod)
      when 'mouse'
        options.dblclickMethod = 'dblclick'
        options.dragMethod = 'drag'
      when 'ctrl_mouse'
        options.dblclickMethod = 'ctrl_dblclick'
        options.dragMethod = 'ctrl_drag'
      when 'alt_mouse'
        options.dblclickMethod = 'alt_dblclick'
        options.dragMethod = 'alt_drag'

    delete options.triggerMethod

  @exports =
    DBLCLICK_METHODS: DBLCLICK_METHODS
    DRAG_METHODS: DRAG_METHODS
    SHORTCUTS: SHORTCUTS
    DEFAULT_OPTIONS: DEFAULT_OPTIONS

    # @return {Promise}
    get: ->
      $$storage.get('options').then (options = {}) =>
        migrateTriggerOption(options)
        _.defaults options, DEFAULT_OPTIONS

    # @return {Promise}
    set: (options = {}) ->
      $$storage.set('options', options)

