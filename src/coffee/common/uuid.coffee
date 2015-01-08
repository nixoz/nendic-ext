@define 'uuid', ->
  generateQuad = ->
    return (65536 * (1 + Math.random()) | 0).toString(16).substring(1)

  @exports =
    generateGuid: ->
      [
        "#{generateQuad()}#{generateQuad()}"
        "#{generateQuad()}"
        "#{generateQuad()}"
        "#{generateQuad()}"
        "#{generateQuad()}#{generateQuad()}#{generateQuad()}"
      ].join('-')