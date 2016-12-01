class window.GameLobby
  @subscribe: (token) =>
    console.log "Subscribing to lobby #{token}"

    App.cable.subscriptions.create { channel: "GameLobbyChannel", lobby: token },
      received: (data) ->
        console.log data
        @appendLine(data)
    
      appendLine: (data) ->
        html = @createLine(data)
        $("[data-game-lobby='#{token}']").append(html)
    
      createLine: (data) ->
        """
        <article class="chat-line">
          <span class="speaker">#{data["user_id"]}</span>
          <span class="body">Joined the lobby!</span>
        </article>
        """
