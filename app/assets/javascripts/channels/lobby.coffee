class window.Lobby

  @subscribe: (token, user_id) =>
    console.log "Subscribing to lobby #{token}"

    App.cable.subscriptions.create { channel: "LobbyChannel", lobby: token, user_id: user_id },
      received: @dispatch

  @dispatch: (data) =>
    console.log data
    command = Object.keys(data)[0]

    if typeof this[command] == 'function'
      this[command](data[command])
    else
      console.log "Unknown command #{command}"

  @user_joined: (data) =>
    @chat(data, 'Joined the lobby.')

  @user_left: (data) =>
    @chat(data, 'Left the lobby.')

  @chat: (lobby_user, message) =>
    $.tmpl($('#lobby-chat-template'), lobby_user: lobby_user, message: message).appendTo('#chat > ul')
