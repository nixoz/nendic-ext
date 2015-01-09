###
애널리틱스

- 스크립트를 추가하면 해당 페이지 뷰 코드를 전달한다.
- 지표를 수집하고 싶은 버튼 엘리먼트에 `data-analytics-event="category:action:label"` 속성을 추가하면,
  클릭 시 지표를 수집한다.
- `$$analytics.trackEvent(eventString)`로 직접 호출할 수 있다.
###
@define 'analytics', ($$message) ->
  _referer = location.href

  # 이벤트 정보를 백그라운드로 전송한다.
  # @param {Object} data
  # @param {String} data.eventString 이벤트 문자열 '카테고리:액션:레이블'
  # @param {String} data.referrer 요청이 발생한 페이지 URL
  sendEventTrackingRequested = $$message.createSenderToExtension 'A:eventTrackingRequested'

  # 페이지 정보를 전송한다.
  # @param {String} pageUrl
  sendPageTrackingRequested = $$message.createSenderToExtension 'A:pageTrackingRequested'

  $(document).on 'mousedown', '[data-analytics-event]', (e) ->
    $target = $(e.currentTarget)
    sendEventTrackingRequested
      eventString: $target.attr('data-analytics-event')
      referrer: _referer

  @exports =
    trackEvent: (eventString) ->
      sendEventTrackingRequested
        eventString: eventString
        referrer: _referer

    trackPage: sendPageTrackingRequested
