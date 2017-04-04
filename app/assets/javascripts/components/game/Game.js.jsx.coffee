@Game = React.createClass
  propTypes:
    currentUser: React.PropTypes.object.isRequired
    lobby: React.PropTypes.object.isRequired
    game: React.PropTypes.object


  getInitialState: ->
    game: @props.game
    currentRound: @props.game?.current_round
    players: @props.game?.players


  componentWillMount: ->
    if !@state.game? && @props.lobby.current_game_id?
      Model.fetch "/games/#{@props.lobby.current_game_id}.json", (game) =>
        @setState game: game, currentRound: game.current_round, players: game.players

    LobbyChannel
      .on 'game', (game) =>
        @setState game: game, currentRound: game.current_round, players: game.players


  _handleNewGame: (e) ->
    Model.post "#{@props.lobby.path}/games.json", {}, (game) =>
      @setState game: game, currentRound: game.current_round, players: game.players
    e.preventDefault()

  _handleJoinGame: (e) ->
    Model.post "#{@state.game.path}/players.json", { user_id: @props.currentUser.id }, (player) =>
      found = @state.players.find (i) -> i.id == player.id

      if !found?
        p = @state.players
        p.push(player)
        @setState players: p

    e.preventDefault()


  render: ->
    if @state.game?
      currentPlayer = @state.players.find (i) =>
        i.user_id == @props.currentUser.id

      if !currentPlayer? # And game is accepting players?
        joinGame =
          `<a href='#' onClick={ this._handleJoinGame }>Join Game</a>`

      else if !@state.game.isReady
        joinGame =
          `<div>Waiting for others...</div>`

      round =
        `<Round round={ this.state.currentRound } game={ this.state.game } />`

      playerList =
        `<PlayerList players={ this.state.players }
                     currentPlayer={ currentPlayer } />`

      children = React.Children.map @props.children, (child) =>
        React.cloneElement child,
          game: this.state.game

    else
      newGame =
        `<a href='#' onClick={ this._handleNewGame }>New Game</a>`

    `<div className="game">
        <div>Game: { JSON.stringify(this.state.game) }</div>

        { newGame }
        { joinGame }

        { playerList }
        { round }
        { children }
    </div>`
