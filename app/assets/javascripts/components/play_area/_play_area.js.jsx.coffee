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
      $.post @props.game.join_url, user_id: @props.lobby_user_id
    e.preventDefault()
    
  render: ->
    joined = =>
      for k, player of @props.players
        return true if player.lobby_user_id == @props.lobby_user_id
      false

    waiting_screen = switch @props.game.status
      when 'starting'
        ready = Object.keys(@props.players).length >= 2
        `<WaitingScreen joined={joined()} ready={ready} onStart={this.startGame} onJoin={this.joinGame} />`

      when 'finished'
        `<div className='margin-top-lg center valign'>
            <div className='caption'>No Game</div>
            <a href='#' className='btn margin-top-lg btn-large' onClick={this.newGame}>New Game</a>
        </div>`

      when 'abandoned'
        `<div className='margin-top-lg center valign'>
            <div className='caption'>Abandoned</div>
            <a href='#' className='btn margin-top-lg btn-large' onClick={this.newGame}>New Game</a>
        </div>`

      when null
        `<div className='no-game center margin-to-lg valign'>
            <h3 className='header grey-text lighten-3'>No games played yet.</h3>
            <a href='#' className='btn margin-top-lg btn-large' onClick={this.newGame}>New Game</a>
        </div>`

      else
        `<h2>{ this.props.game.status }</h2>`

    `<div id='play-area'>
        <div className='valign-wrapper center'>{ waiting_screen }</div>
        <RoundHand round={this.props.round} />
        <PlayerList players={this.props.players} />
        <user-hand lobby_user_id={this.props.lobby_user_id} />
        <StatusBar game={this.props.game} />
    </div>`
