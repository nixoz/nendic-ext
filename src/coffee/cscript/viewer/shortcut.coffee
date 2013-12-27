###
뷰어의 단축키 모듈
###
define [
  "jquery"
], ($) ->
  
  ALPHABET = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
  
  SPECIAL =
    27: "esc"
    191: "/"

  _callbackMap = {}
  
  # keydown으로 바인딩하면,
  # 한글일 때 키코드를 정확히 찾지 못하는 버그가 있다.
  # keyup으로 이벤트를 할당한다.
  findKey = (keyCode) ->
    return ALPHABET[keyCode - 65] if 65 <= keyCode <= 90
    SPECIAL[keyCode]

  $(document).on "keyup", (e) ->
    key = findKey(e.keyCode)
    cbs = _callbackMap[key] if key
    cb() for cb in cbs if cbs

  return (
    # 단축키 콜백을 할당한다.
    # @param {String} key 키명. 'a', 'b'와 같은 키 이름
    # @param {Function} callback 실행할 콜백
    # @param {Function} cond 콜백을 실행할 조건
    on: (key, callback, cond) ->
      _callbackMap[key] or= []
      _callbackMap[key].push ->
        switch typeof cond
          when "undefined"
            callback()
          when "function"
            cond() and callback()
          else
            cond and callback()

      this
  )