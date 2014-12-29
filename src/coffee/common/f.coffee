###
함수형 프로그래밍을 위한 유틸리티
###
@f_ =
  # 여러 조건을 만족하는 체커 함수를 생성한다.
  # @example
  # validator = f_.validator isConditionA, isConditionB, isConditionC
  # validator 'targetValA', 'targetValB'
  validator: ->
    funcs = _.toArray arguments
    return ->
      args = _.toArray arguments
      _.every funcs, (func) ->
        func.apply null, args
