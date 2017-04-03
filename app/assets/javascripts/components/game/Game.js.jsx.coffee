@Game = React.createClass
  propTypes:
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


  _handleNewGame: (e) ->
    Model.post "#{@props.lobby.path}/games.json", {}, (game) =>
      @setState game: game, currentRound: game.current_round, players: game.players
    e.preventDefault()


  render: ->
    if @state.game?
      children = React.Children.map @props.children, (child) =>
        React.cloneElement child,
          game: this.state.game

      round =
        `<Round round={ this.state.currentRound } game={ this.state.game } />`

      playerList =
        `<PlayerList players={ this.state.players } />`

    else
      newGame =
        `<a href='#' onClick={ this._handleNewGame }>New Game</a>`

    `<div className="game">
        <div>Game: { JSON.stringify(this.state.game) }</div>

        { newGame }

        { round }
        { playerList }
        { children }
    </div>`
