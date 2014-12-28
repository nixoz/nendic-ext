###
함수형 프로그래밍을 위한 유틸리티
###
@f_ =
  validate: (param) ->
  	funcs = _.rest(arguments)
  	_.every(funcs, (f) ->
  		f(param)
  	)