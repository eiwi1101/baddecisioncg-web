@App = React.createClass
  getInitialState: ->
    lobby_user_id: @props.lobby_user_id
    lobby: @props.lobby
    game: @props.game
    players: @props.game.players
    round: @props.game.current_round
    users: @props.users
    messages: @props.messages

  componentWillMount: ->
    console.log 'Initializing the application!'

  componentDidMount: ->
    LobbyChannel.subscribe this.state.lobby.token, this.state.lobby_user_id,
      player_join: (player) =>
        @setState players: @state.players.merge player.guid => player

  render: ->
    lobby_user = this.state.users[this.state.lobby_user_id]
    signed_in = lobby_user? && lobby_user.user?

    `<div id='game-area'>
        <PlayArea players={this.state.players} round={this.state.round} game={this.state.game} lobby_user_id={this.state.lobby_user_id} />
        <Aside lobby={this.state.lobby} messages={this.state.messages} users={this.state.users} lobby_user_id={this.state.lobby_user_id} signed_in={signed_in} />
    </div>`
