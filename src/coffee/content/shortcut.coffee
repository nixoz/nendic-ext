class Shortcut
  constructor: ->
    $(document).on 'click', (e) ->
      window.top.postMessageToViewer()

new Shortcut