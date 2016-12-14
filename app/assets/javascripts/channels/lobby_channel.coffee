class window.LobbyChannel
  @callbacks = {}

  @subscribe: (token, user_id, callbacks={}) =>
    App.cable.subscriptions.create { channel: "LobbyChannel", lobby: token, user_id: user_id },
      received: @dispatch
      connected: @connected
      disconnected: @disconnected
      rejected: @rejected
      away: @away
      appear: @appear

    for action, callback of callbacks
      @on action, callback

  @disconnected: =>
    console.log "[turret: are you still there?]"
    @dispatch disconnect: null

  @connected: =>
    console.log "[oh. hello there. i missed you.]"
    @dispatch connect: null

  @rejected: =>
    console.log "... that's harsh, yo."
    @dispatch reject: null

  @dispatch: (data) =>
    command = Object.keys(data)[0]
    console.log 'Got ', data

    if @callbacks[command] != undefined
      $.each @callbacks[command], (index, callback) ->
        callback(data[command])

  @on: (command, callback) ->
    @callbacks[command] = [] unless @callbacks[command] != undefined
    @callbacks[command].push callback
