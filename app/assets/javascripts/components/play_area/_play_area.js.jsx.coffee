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

    LobbyChannel.on 'game_start', (game) =>
      @setState game: game

    LobbyChannel.on 'game_finished', (game) =>
      @setState game: game, round: null, players: null

    LobbyChannel.on 'next_round', (round) =>
      @setState round: round

    LobbyChannel.on 'player_join', (player) =>
      @setState players: @state.players.concat(player)

    LobbyChannel.on 'player_leave', (player) =>
      @setState players: @state.players.filter (el) ->
        el.guid != player.guid

    LobbyChannel.on 'player_won', (player) =>
      console.log 'A PLAYER WON'

  newGame: (e) ->
    if !@state.game || @state.game.status = 'finished'
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

    if @state.game && @state.game.status == null
      waiting_screen = `<WaitingScreen joined={joined} onStart={this.startGame} onJoin={this.joinGame} />`

    if !@state.game || ( @state.game && ( @state.game.status == 'finished' || @state.game.status == 'abandoned') )
      waiting_screen =
        `<div className='margin-top-lg center'>
            <div className='caption'>No Game</div>
            <a href='#' className='btn margin-top-lg btn-large' onClick={this.newGame}>New Game</a>
        </div>`

    debug = JSON.stringify @props, null, 2

    `<div id='play-area'>
        { waiting_screen }
        <round-hand round={this.state.round} />
        <PlayerList players={this.state.players} />
        <user-hand lobby_user={this.props.lobby_user} />
    </div>`
