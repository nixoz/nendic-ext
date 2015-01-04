###
애널리틱스

- 스크립트를 추가하면 해당 페이지 뷰 코드를 전달한다.
- 지표를 수집하고 싶은 버튼 엘리먼트에 `data-analytics-event="category:action:label"` 속성을 추가하면,
  클릭 시 지표를 수집한다.
- `$$analytics.track(category, action)`로 직접 호출할 수 있다.
###
`
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
`
@ga 'create', 'UA-30985671-8', 'auto'
@ga 'set', 'forceSSL', true # 익스텐션은 모두 SSL로 보내야 한다.
@ga 'set', 'checkProtocolTask', null # 프로토콜 체킹 없이 보낸다.
@ga 'send', 'pageview', useBeacon: true

trackEvent = (category, action = '', label = '') ->
  @ga 'send', 'event', category, action, label, useBeacon: true

$(document).on 'mousedown', '[data-analytics-event]', (e) ->
  $target = $(e.currentTarget)
  infos = $target.attr('data-analytics-event').split(':')
  trackEvent.apply(null, infos)

@$$analytics =
  track: trackEvent