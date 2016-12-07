class window.Lobby

  @subscribe: (token) =>
    console.log "Subscribing to lobby #{token}"

    App.cable.subscriptions.create { channel: "LobbyChannel", lobby: token },
      received: @dispatch

  @dispatch: (data) =>
    console.log data
    command = Object.keys(data)[0]

    if typeof this[command] == 'function'
      this[command](data[command])
    else
      console.log "Unknown command #{command}"

  @user_joined: (data) =>
    $('[data-game-lobby]').append """
      <div class="teal-text">#{data.user.display_name} has joined the lobby.</div>
    """

  @user_left: (data) =>
    $('[data-game-lobby]').append """
      <div class="red-text">#{data.user.display_name} has left.</div>
    """
