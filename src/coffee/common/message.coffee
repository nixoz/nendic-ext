###
익스텐션과 컨텐트 스크립트의 메시지 전달을 위함 함수 모음이다.

- 모든 데이터는 아래 포맷으로 전달하지만, 함수 밖에선 name, data 파라미터로 추상화한다.
  {
    name: '이름',
    data: '데이터' 
  }
- 모든 이벤트명은 과거형으로 작성한다.
- 백그라운드에서 보내는 메시지는 'B:XXX'로 이름을 정한다.
- 각 탭에서 보내는 메시지는 'T:XXX'로 이름을 정한다.
- 메시지 리스너를 리턴하는 함수명은 `whenXXX` 형태로 정한다.
- 메시지를 전송하는 함수명은 `sendXXXTo` 형태로 정한다.
###
@define 'message', ->
  @exports =
    createSenderToExtension: (name) ->
      (data) ->
        chrome.runtime.sendMessage
          name: name
          data: data

    createListenerToExtension: (name) ->
      (handler) ->
        chrome.runtime.onMessage.addListener (req, sender) ->
          handler(req.data) if req.name is name

    createSenderToTab: (name) ->
      (data) ->
        chrome.tabs.query
          active: true
          currentWindow: true
        , (tabs) ->
          chrome.tabs.sendMessage tabs[0].id,
            name: name
            data: data

    createListenerToTab: (name) ->
      (handler) ->
        chrome.runtime.onMessage.addListener (req, sender) ->
          if sender.tab
            handler(req.data) if req.name is name

    createSenderToPopup: (name) ->
      (data) ->
        chrome.runtime.sendMessage
          name: name
          data: data

    createListenerToPopup: (name) ->
      (handler) ->
        chrome.runtime.onMessage.addListener (req, sender) ->
          handler(req.data) if req.name is name

    createSenderToWindow: (win, name) ->
      (data) ->
        isValidTargetWindow = true
        try
          # 크로스 도메인 이슈로 대상 window에 접근할 수 없다면 메시지를 보내지 않는다.
          # 원래 `targetOrigin`이 동일하지 않으면 메시지를 보내지 않는데,
          # `postMessage()` 호출 시 에러가 발생해버린다.
          # 더군다가 이 에러가 try catch로 잡히지 않아, 다른 속성을 조회하는 방법으로 우회한다.
          win.location.href
        catch error
          isValidTargetWindow = false
        
        if isValidTargetWindow
          win.postMessage
            name: name 
            data: data
          , chrome.extension.getURL('')

    createListenerToWindow: (name) ->
      (handler) ->
        window.addEventListener 'message', (e) ->
          # 크롬 익스텐션에서 온 요청만 허용한다.
          # 익스텐션의 getURL()에는 슬래시가 붙어있어서 오리진과 비교하기 위해 제거한다.
          return unless e.origin is chrome.extension.getURL('').replace(/\/$/, '')

          if e.data and e.data.name is name
            handler e.data.data