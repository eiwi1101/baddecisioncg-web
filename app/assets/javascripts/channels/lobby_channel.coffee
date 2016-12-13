class window.LobbyChannel
  @callbacks = {}

  @subscribe: (token, user_id, callbacks={}) =>
    console.log 'Listening for events.'
    App.cable.subscriptions.create { channel: "LobbyChannel", lobby: token, user_id: user_id },
      received: @dispatch
      connected: @connected
      disconnected: @disconnected

    for action, callback in callbacks
      @on action, callback

  @disconnected: ->
    console.log 'disconnected'

  @connected: ->
    console.log 'connected!!'

  @dispatch: (data) =>
    console.log data
    command = Object.keys(data)[0]

    if @callbacks[command] != undefined
      $.each @callbacks[command], (index, callback) ->
        callback(data[command])

  @on: (command, callback) ->
    @callbacks[command] = [] unless @callbacks[command] != undefined
    @callbacks[command].push callback
