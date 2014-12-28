###
검색 결과의 '단어 제목' 부분을 파싱하는 모듈
###
_$wrapper = null

# 부모 엘리먼트에서 셀렉터에 해당하는 엘리먼트를 찾은 후,
# 타입에 해당하는 값을 가져온다.
# 
# @param {Element} parent 부모 엘리먼트
# @param {String} selector 셀렉터
# @param {String} type 검색할 타입
#   text: 해당 DOM의 텍스트를 가져온다.
#   href: href 값에 영어사전 주소를 붙여 가져온다.
#   기본값: 속성을 가져온다.
find = (parent, selector, type) ->
  target = (parent.find(selector) if selector) or parent
  host = "http://endic.naver.com"

  switch type
    when "text"
      target.text().trim()
    when "href"
      href = target.attr("href") or ""
      href = host + href if href
      href
    else
      attr = target.attr(type) or ""
      attr

# 기준 래퍼를 할당한다.
setWrapper = (elWrapper) ->
  _$wrapper = $(elWrapper)

# HTML을 파싱한다.
parseHtmlToData = ->
  # 단어 제목
  title: find(_$wrapper, ".t1 strong", "text") or find(_$wrapper, ".t1 a", "text")
  # 몇 번째 단어인지
  number: find(_$wrapper, ".t1 sup", "text")
  # 영어사전 검색 URL
  url: find(_$wrapper, ".t1 a", "href")
  # 발음 기호
  phonetic_symbol: find(_$wrapper, ".t2", "text")
  # 영어 발음 재생 URL
  pronunciation: find(_$wrapper, "#pron_en", "playlist")

# DOM을 초기화하고 메모리 해제한다.
reset = ->
  _$wrapper.remove()
  _$wrapper = null


@wordParser_ =
  # 기준 래퍼를 할당한다.
  setWrapper: (elWrapper) ->
    setWrapper elWrapper

  # HTML을 파싱한다.
  parse: ->
    parsed = parseHtmlToData()
    reset()
    parsed