@App = React.createClass
  getInitialState: ->
    lobby_user_id: @props.lobby_user_id
    lobby: @props.lobby
    game: @props.game
    players: @props.game.players
    round: @props.game.current_round
    users: @props.users
    messages: @props.messages # Optional
    connected: true
    playerHand: {}

  componentDidMount: ->
    console.log @state

    $.get @state.lobby.messages_url, (messages) =>
      @setState messages: messages
      
    LobbyChannel.subscribe { token: @state.lobby.token, lobby_user_id: @state.lobby_user_id },
      disconnect: =>
        @setState connected: false
      connect: =>
        @setState connected: true

      player: (player) =>
        players = @state.players
        if player.is_deleted
          delete players[player.guid]
        else
          players[player.guid] = player
        @setState players: players

      user: (user) =>
        users = @state.users
        if user.is_deleted
          delete users[user.guid]
        else
          users[user.guid] = user
        @setState users: users

      game: (game) =>
        if game.guid != @state.game.guid
          @setState players: game.players, round: game.current_round, playerHand: {}
        @setState game: game

      round: (round) =>
        @setState round: round

      lobby: (lobby) =>
        @setState lobby: lobby

    LobbyUserChannel.subscribe { lobby_user_id: @state.lobby_user_id },
      player: (player) =>
        if player.cards
          for key, card of player.cards
            @state.playerHand[card.type] = {} unless @state.playerHand[card.type]
            if card.is_discarded then delete @state.playerHand[card.type][card.guid]
            else @state.playerHand[card.type][card.guid] = card
      
  render: ->
    lobby_user = @state.users[@state.lobby_user_id]
    signed_in = lobby_user? && lobby_user.user?

    if @state.round
      bard_guid = @state.round.bard_player_guid

    if @state.connected
      `<div id='game-area'>
          <PlayArea players={this.state.players} game={this.state.game} lobby={this.state.lobby} lobby_user_id={this.state.lobby_user_id}>
              <PlayerList players={this.state.players} bard_guid={bard_guid} />
              <div className='grow valign-wrapper center'>
                  <RoundHand selectWinnerUrl={this.state.game.winner_card_url} round={this.state.round} />
              </div>
              <PlayerHand playUrl={this.state.game.play_card_url} foolHand={this.state.playerHand.fool} crisisHand={this.state.playerHand.crisis} badDecisionHand={this.state.playerHand.bad_decision} />
              <StatusBar game={this.state.game} round={this.state.round} />
          </PlayArea>

          <Aside>
              <Chat lobby={this.state.lobby} users={this.state.users} messages={this.state.messages} lobby_user_id={this.state.lobby_user_id} />
              <UserList lobby_user_id={this.state.lobby_user_id} users={this.state.users} />
              <Settings />

              <ChatForm action={this.state.lobby.messages_url} signed_in={signed_in} disabled={this.state.messages == null } />
          </Aside>
      </div>`
    else
      `<div id='game-area'>
          <div id='play-area' style={{width: '100%'}}>
              <div className='valign-wrapper'>
                  <div className='valign center'>
                      <Preloader />
                      <p className='caption margin-top-lg'>Connecting to server...</p>
                  </div>
              </div>
          </div>
      </div>`
