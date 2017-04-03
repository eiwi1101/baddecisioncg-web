@Model =
  fetch: (path, success, error) ->
    $(document).trigger 'app:loading'

    $.get
      url: path
      success: success

      error: (e) =>
        msg = e.responseJSON || e.responseText
        console.error msg
        error(msg) if error?

      always: =>
        $(document).trigger 'app:loading:stop'
