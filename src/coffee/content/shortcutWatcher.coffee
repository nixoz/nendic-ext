###
키가 클릭되면 백그라운드로 메시지를 보낸다.
###
@define 'shortcutWatcher', ($$message, $$options) ->
  ALPHABET = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
  
  SPECIAL =
    27: 'esc'
    13: 'enter'

  # 사용하는 단축키
  whitelist = _.keys $$options.SHORTCUTS
  
  sendShortcutPressed = $$message.createSenderToExtension 'T:shortcutPressed'

  # keydown으로 바인딩하면,
  # 한글일 때 키코드를 정확히 찾지 못하는 버그가 있다.
  # keyup으로 이벤트를 할당한다.
  findKey = (keyCode) ->
    return ALPHABET[keyCode - 65] if 65 <= keyCode <= 90
    SPECIAL[keyCode]

  (->
    $$options.get().then (options) ->
      return unless options.useShortcut

      $(document).on 'keyup', (e) ->
        target = e.target

        # 텍스트 입력창이라면 무시한다. 단, 스페셜 키인 경우엔 허용한다.
        return if /(input|textarea)/i.test(target.tagName) and
            e.keyCode not of SPECIAL

        key = findKey(e.keyCode)
        sendShortcutPressed key if _.contains(whitelist, key)
  )()