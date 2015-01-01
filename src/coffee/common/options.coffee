###
영어사전 익스텐션의 옵션
###
# @return {Promise}
TRIGGER_METHODS = (->
  ctrlKeyName = if navigator.platform is 'MacIntel' then '<Cmd>' else '<Ctrl>'
  altKeyName = '<Alt>'
  mouseMethodDesc = '<더블클릭 또는 마우스로 드래그>'
  
  [
    { value: 0, desc: "#{mouseMethodDesc}" }
    { value: 1, desc: "#{ctrlKeyName} + #{mouseMethodDesc}"}
    { value: 2, desc: "#{altKeyName} + #{mouseMethodDesc}"}
  ]
)()

DEFAULT_OPTIONS =
  triggerMethod: TRIGGER_METHODS[0].value

@$$options =
  TRIGGER_METHODS: TRIGGER_METHODS
  DEFAULT_OPTIONS: DEFAULT_OPTIONS

  # @return {Promise}
  get: ->
    $$storage.get('options').then (options = {}) =>
      _.defaults options, DEFAULT_OPTIONS

  # @return {Promise}
  set: (options = {}) ->
    $$storage.set('options', options)

