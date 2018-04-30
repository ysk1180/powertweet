ready = ->

  # text_areaの部分のkeyupイベントが発生したら文字数を計測し、表示
  $("#content").keyup ->
    $("p#content_check").html(count_length)

  # 文字数を計測し、表示する文字列を作成("X文字"の部分)
  count_length = ->
    msg = $("#content").val().length + "文字 / max 120文字"
    return msg

$(document).ready(ready)
$(document).on('turbolinks:load', ready)

ready = ->

  # text_areaの部分のkeyupイベントが発生したら文字数を計測し、表示
  $("#power").keyup ->
    $("p#power_check").html(count_length)

  # 文字数を計測し、表示する文字列を作成("X文字"の部分)
  count_length = ->
    msg = $("#power").val().length + "文字 / max 90文字"
    return msg

$(document).ready(ready)
$(document).on('turbolinks:load', ready)
