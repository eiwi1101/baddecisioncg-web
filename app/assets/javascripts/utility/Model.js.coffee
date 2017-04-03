@Model =
  fetch: (path, success, error) ->
    @request('GET', path, {}, success, error)

  post: (path, data, success, error) ->
    @request('POST', path, data, success, error)

  request: (type, path, data, success, error) ->
    $(document).trigger 'app:loading'
    console.debug "#{type} #{path}", data

    $.ajax
      url: path
      type: type
      data: data
      success: success

      error: (e) =>
        msg = e.responseJSON || e.responseText
        console.error msg
        error(msg) if error?

      complete: =>
        $(document).trigger 'app:loading:stop'
