@PlayArea = React.createClass
  getInitialState: ->
    if @props.game
      {
        game: @props.game
        round: @props.game.current_round
        players: @props.game.players
      }
    else
      {
        game: null
        round: null
        players: []
      }

  componentDidMount: ->
    LobbyChannel.on 'new_game', (game) =>
      @setState game: game

    LobbyChannel.on 'player_join', (player) =>
      @setState players: @state.players.concat(player)

  newGame: (e) ->
    if !@state.game
      $.post @props.lobby.new_game_url
    e.preventDefault()

  startGame: (e) ->
    if @state.game
      $.post @state.game.start_url
    e.preventDefault()

  joinGame: (e) ->
    if @state.game
      $.post @state.game.join_url, user_id: @props.lobby_user.guid
    e.preventDefault()
    
  render: ->
    joined = @state.players.some (player) =>
      player.lobby_user_id == @props.lobby_user.guid

    if @state.game
      if @state.game.status == null
        content = `<WaitingScreen joined={joined} onStart={this.startGame} onJoin={this.joinGame} />`
      else
        content = `<h1>Insert game here.</h1>` #<Game game={this.state.game} players={this.state.players} />`
    else
      content =
        `<div className='margin-top-lg center'>
            <div className='caption'>No Game</div>
            <a href='#' className='btn margin-top-lg btn-large' onClick={this.newGame}>New Game</a>
        </div>`

    `<div id='play-area'>
        { content }
    </div>`
