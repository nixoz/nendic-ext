###
공지사항 처리를 위해 뉴 뱃지
###
@define 'newBadge', ($$storage) ->

  _currentVersion = chrome.runtime.getManifest().version
  _isVersionDifferent = false

  showNewBadge = ->
    chrome.browserAction.setBadgeText
      text: 'N'
    $('[data-new-badge]').show()

  hideNewBadge = ->
    chrome.browserAction.setBadgeText
      text: ''

  # 버전이 다를 경우 뉴 뱃지를 보여준다.
  # 뱃지의 스타일은 각 뷰에서 처리하되, 기본값은 display:none; 처리한다.
  $$storage.get('version').then (version) ->
    console.log '>>>>', version, _currentVersion
    unless version is _currentVersion
      console.log '헐?'
      _isVersionDifferent = true

      # 백그라운드 페이지일 경우, 브라우저 액션의 뱃지를 보여주고 컨텐트일 경우 문서를 검색한다.
      if location.pathname is '/_generated_background_page.html'
        showNewBadge()
      else
        $(->
          $('[data-new-badge]').show()
        )

  @exports =
    # 저장된 키 값을 최신 버전으로 업데이트한다.
    # 브라우저 액션의 뉴 뱃지를 제거한다.
    # 컨텐츠들은 닫으면 없어지므로 그대로 둔다.
    updateToCurrentVersion: ->
      if _isVersionDifferent
        $$storage.set('version', _currentVersion).then ->
          hideNewBadge()
          _isVersionDifferent = false