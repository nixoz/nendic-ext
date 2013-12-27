require [
  "jquery"
], ($) ->
  
  $searchWord = $("search-button")
  $searchButton = $("search-word")

  $searchWord.click (e) ->
    alert $searchWord.val()
