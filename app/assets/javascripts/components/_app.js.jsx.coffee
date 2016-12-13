@App = React.createClass
  getInitialState: ->
    lobby_user_id: @props.lobby_user_id
    lobby: @props.lobby
    game: @props.game
    players: @props.game.players
    round: @props.game.current_round
    users: @props.users
    messages: @props.messages
    connected: false

  componentDidMount: ->
    LobbyChannel.subscribe this.state.lobby.token, this.state.lobby_user_id,
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
        console.log players
        @setState players: players

      user: (user) =>
        users = @state.users
        if user.is_deleted
          delete users[user.guid]
        else
          users[user.guid] = user
        console.log users
        @setState users: users
        
      game: (game) =>
        console.log game
        @setState game: game
      
      round: (round) =>
        console.log round
        @setState round: round
        
      lobby: (lobby) =>
        console.log lobby
        @setState lobby: lobby
      
    console.log 'Ready!'
      
  render: ->
    lobby_user = this.state.users[this.state.lobby_user_id]
    signed_in = lobby_user? && lobby_user.user?

    if @state.connected
      `<div id='game-area'>
          <PlayArea players={this.state.players} round={this.state.round} game={this.state.game} lobby={this.state.lobby} lobby_user_id={this.state.lobby_user_id} />
          <Aside lobby={this.state.lobby} messages={this.state.messages} users={this.state.users} lobby_user_id={this.state.lobby_user_id} signed_in={signed_in} />
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
