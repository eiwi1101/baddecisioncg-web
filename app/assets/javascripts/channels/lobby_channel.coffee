class window.LobbyChannel
  @callbacks = {}

  @subscribe: (token, user_id, callbacks={}) =>
    App.cable.subscriptions.create { channel: "LobbyChannel", lobby: token, user_id: user_id },
      received: @dispatch
      connected: @connected
      disconnected: @disconnected

    console.log callbacks
    for action, callback of callbacks
      console.log 'Hooking into ' + action
      @on action, callback

  @disconnected: =>
    @dispatch(disconnect: {})

  @connected: =>
    @dispatch(connect: {})

  @dispatch: (data) =>
    console.log data
    command = Object.keys(data)[0]

    if @callbacks[command] != undefined
      $.each @callbacks[command], (index, callback) ->
        callback(data[command])

  @on: (command, callback) ->
    @callbacks[command] = [] unless @callbacks[command] != undefined
    @callbacks[command].push callback
