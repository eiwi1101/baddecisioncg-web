class window.Lobby
  @subscribe: (token, user_id) =>
    console.log 'Listening for events.'
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

  @message: (data) =>
    @chat(data.lobby_user, data.message)

  @chat: (lobby_user, message) =>
    $chat = $('#chat')
    $.tmpl($('#lobby-chat-template'), lobby_user: lobby_user, message: message).appendTo $chat
    $chat.scrollTop $chat[0].scrollHeight
