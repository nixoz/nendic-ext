###
애널리틱스

- 스크립트를 추가하면 해당 페이지 뷰 코드를 전달한다.
- 지표를 수집하고 싶은 버튼 엘리먼트에 `data-analytics-event="category:action:label"` 속성을 추가하면,
  클릭 시 지표를 수집한다.
- `$$analytics.track(eventString)`로 직접 호출할 수 있다.
###
@define 'analytics', ($$message) ->
  _referer = location.href

  # 이벤트 정보를 백그라운드로 전송한다.
  # @param {String} eventString 이벤트 문자열 '카테고리:액션:레이블'
  sendTrackingRequested = $$message.createSenderToExtension 'A:trackingRequested'

  $(document).on 'mousedown', '[data-analytics-event]', (e) ->
    $target = $(e.currentTarget)
    sendTrackingRequested
      eventString: $target.attr('data-analytics-event')
      referrer: _referer

  @exports =
    track: (eventString) ->
      sendTrackingRequested
        eventString: eventString
        referrer: _referer