class window.GameLobby
  @subscribe: (token) =>
    console.log "Subscribing to lobby #{token}"

    App.cable.subscriptions.create { channel: "GameLobbyChannel", lobby: token },
      received: (data) ->
        console.log data
        @appendLine(data)
    
      appendLine: (data) ->
        html = @createLine(data)
        $("[data-chat='#{token}']").append(html)
    
      createLine: (data) ->
        """
        <article class="chat-line">
          <span class="speaker">#{data["sent_by"]}</span>
          <span class="body">#{data["body"]}</span>
        </article>
        """
