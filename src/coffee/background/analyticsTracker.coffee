###
애널리틱스 수집 모듈

모든 애널리틱스 지표는 백그라운드에서 처리한다.
뷰어나 다른 모듈에서는 바로 수집하는 대신 백그라운드로 메시지를 보낸다.
###
@define 'analyticsTracker', ($$constant, $$uuid, $$storage, $$message) ->

  whenTrackingRequested = $$message.createListenerToExtension 'A:trackingRequested'

  startTracking = (clientId) ->
    # @ga_debug = true
    # `
    # (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    # (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    # m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    # })(window,document,'script','https://www.google-analytics.com/analytics_debug.js','ga');
    # `

    `
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
    `
    @ga 'create', $$constant.ANALYTICS_ID,
      'storage': 'none'
      'clientId': clientId
    @ga 'set', 'forceSSL', true # 익스텐션은 모두 SSL로 보내야 한다.
    @ga 'set', 'checkProtocolTask', null # 프로토콜 체킹 없이 보낸다.
    @ga 'send', 'pageview', useBeacon: true

  # 이벤트를 전송한다.
  # @param {String} eventString 이벤트 문자열 '카테고리:액션:레이블'
  track = (eventString) ->
    [category, action, label] = eventString.split(':')
    @ga 'send', 'event', category, action, label, useBeacon: true 

  $$storage.get('clientId')
    .then (clientId) ->
      return clientId if clientId

      $$storage.set('clientId', $$uuid.generateGuid()).then () ->
        $$storage.get('clientId')

    .then (clientId) ->
      startTracking clientId
      whenTrackingRequested track
