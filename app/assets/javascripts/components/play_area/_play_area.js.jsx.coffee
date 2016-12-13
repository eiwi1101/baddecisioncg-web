@PlayArea = React.createClass
  newGame: (e) ->
    if !@props.game || @props.game.status = 'finished'
      $.post @props.lobby.new_game_url
    e.preventDefault()

  startGame: (e) ->
    if @props.game
      $.post @props.game.start_url
    e.preventDefault()

  joinGame: (e) ->
    if @props.game
      $.post @props.game.join_url, user_id: @props.lobby_user.guid
    e.preventDefault()
    
  render: ->
    joined = @props.players.some (player) =>
      player.lobby_user_id == @props.lobby_user_id

    if @props.game && @props.game.status == null
      waiting_screen = `<WaitingScreen joined={joined} onStart={this.startGame} onJoin={this.joinGame} />`

    if !@props.game || ( @props.game && ( @props.game.status == 'finished' || @props.game.status == 'abandoned') )
      waiting_screen =
        `<div className='margin-top-lg center'>
            <div className='caption'>No Game</div>
            <a href='#' className='btn margin-top-lg btn-large' onClick={this.newGame}>New Game</a>
        </div>`

    debug = JSON.stringify @props, null, 2

    `<div id='play-area'>
        { waiting_screen }
        <round-hand round={this.props.round} />
        <PlayerList players={this.props.players} />
        <user-hand lobby_user_id={this.props.lobby_user_id} />
    </div>`
