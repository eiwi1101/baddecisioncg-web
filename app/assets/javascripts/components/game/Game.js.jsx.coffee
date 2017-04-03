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


  render: ->
    children = React.Children.map @props.children, (child) =>
      React.cloneElement child,
        game: this.state.game

    `<div className="game">
        <div>Game: { JSON.stringify(this.state.game) }</div>

        <Round game={ this.state.game }
               round={ this.state.currentRound } />

        <PlayerList game={ this.state.game }
                    players={ this.state.players } />

        { children }
    </div>`
