###
의존 모듈을 정의한다.

각 파일이 의존하고 있는 모듈을 코드 상에서 확인하기 위한 간단한 define 함수이다.
아래와 같이 정의하며, 의존 모듈은 파라미터명으로 가져온다.

define 'moduleName', ($$foo, $$bar, $$baz) ->
  ...
  exports.foo = 'xxx' # exports 를 활용하거나,
  exports = {} # 새 값을 정의할 수 있다.

의존 모듈의 이름은 `$$XXX`와 같은 형태로 정의한다.
의존 파일은 미리 순서대로 정의해야 하고, 이 파일이 의존하고 있는 모듈을 동적으로 가져오진 않는다.
개발 편의와 혼란을 위해 적용한 간단한 모듈이다.
###
_rArg = /^function\s*[^\(]*\(\s*([^\)]*)\)/m
_rArgSplit = /,/
_rModulePrefix = /^\$\$/
_rComment = /((\/\/.*$)|(\/\*[\s\S]*?\*\/))/mg

getDependencies = (currentModuleName, fn) =>
  fnText = fn.toString().replace(_rComment, '')
  argDecl = fnText.match(_rArg)
  modules = []

  _.each argDecl[1].split(_rArgSplit), (arg) ->
    moduleName = arg.trim().replace(_rModulePrefix, '')
    if moduleName
      throw """
      Error when defining #{currentModuleName}: Can't find module '#{moduleName}'
      """ unless moduleName of @define._modules
      modules.push @define._modules[moduleName]

  modules

@define = (moduleName, def) ->
  @define._modules or= {}
  throw "Module #{moduleName} is already defined" if moduleName of @define._modules

  # 전역으로 exports 를 할당한다.
  @exports = {}
  # 모듈 정의를 바로 실행한다. 모듈에서는 `exports`에 값을 추가하거나 새 exports 를 할당할 수 있다.
  def.apply(null, getDependencies(moduleName, def))
  # 전역으로 할당된 exports 를 가져온다.
  @define._modules[moduleName] = @exports
  @exports = undefined # 한 번 가져온 값은 초기화한다.