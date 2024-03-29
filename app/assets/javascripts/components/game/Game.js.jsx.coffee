@Game = React.createClass
  propTypes:
    currentUser: React.PropTypes.object.isRequired
    lobby: React.PropTypes.object.isRequired
    game: React.PropTypes.object

  childContextTypes:
    currentRound: React.PropTypes.object
    currentGame: React.PropTypes.object
    currentPlayer: React.PropTypes.object


  getChildContext: ->
    currentRound: @state.currentRound
    currentGame: @state.game
    currentPlayer: @state.currentPlayer

  # TODO -> Current player.
  getInitialState: ->
    game: @props.game
    currentRound: @props.game?.current_round
    players: @props.game?.players
    currentPlayer: null


  load: (game=null) ->
    if game
      o = game: game
      o.currentRound = game.currentRound if game.currentRound
      o.players = game.players if game.players
      @setState o
    else
      Model.fetch "/games/#{@props.lobby.current_game_id}.json", @load

  componentWillMount: ->
    if !@state.game? && @props.lobby.current_game_id?
      @load()

    LobbyChannel
      .on 'game', (game) =>
        @load game

      .on 'player', (player) =>
        if player.isDeleted
          StateUtils.removeItem @, 'players', player, 'id'
        else
          StateUtils.updateItem @, 'players', player, 'id'


  _handleGameStart: ->
    SoundEffect.play 'gameStart'

  _handleNewRound: (round) ->
    console.debug '[Game] New Round: ' + round.id
    @_handleGameStart() unless @state.currentRound
    @setState currentRound: round

  _handleNewGame: (e) ->
    Model.post "#{@props.lobby.path}/games.json", {}, (game) =>
      @setState game: game, currentRound: game.current_round, players: game.players

    e.preventDefault()

  _handleJoinGame: (e) ->
    Model.post "#{@state.game.path}/players.json", { user_id: @props.currentUser.id }, (player) =>
      if !@_findPlayer(player.user_id)
        p = @state.players
        p.push(player)
        @setState players: p
    e.preventDefault()

  _findPlayer: (userId) ->
    @state.players? and (i for i in @state.players when i.user_id is userId)[0]

  _handleChatToggle: (e) ->
    $('body').toggleClass 'chat-open'
    $(window).trigger 'resize'
    e.preventDefault()


  render: ->
    if @state.game?
      currentPlayer = @_findPlayer(@props.currentUser.id)

      if !currentPlayer? # And game is accepting players?
        joinGame =
          `<a href='#' className='action-button' onClick={ this._handleJoinGame }>Join Game</a>`

      else
        if !@state.game.isReady
          joinGame =
            `<div className='status-box'>Waiting for others...</div>`

        playerHands =
          `<PlayerHands currentUser={ this.props.currentUser }
                        currentPlayer={ currentPlayer }
                        cards={ currentPlayer.cards } />`

      round =
        `<Round round={ this.state.currentRound }
                game={ this.state.game }
                onChange={ this._handleNewRound }
                currentPlayer={ currentPlayer }
        />`

      playerList =
        `<PlayerList players={ this.state.players }
                     currentPlayer={ currentPlayer } />`

      children = React.Children.map @props.children, (child) =>
        React.cloneElement child,
          game: this.state.game

      if @state.game.status == 'finished'
        newGame =
          `<a href='#' className='action-button' onClick={ this._handleNewGame }>New Game</a>`

    else
      newGame =
        `<a href='#' className='action-button' onClick={ this._handleNewGame }>New Game</a>`

    `<div className='play-area'>
        <div id='game-data' className='debug-data'>Game: { JSON.stringify(this.state.game) }</div>

        <div className='lobby-data'>
            <div className='right'>
                <div className='current-user'>
                    <img className='avatar' src={ this.props.currentUser.avatar_url } alt={ this.props.currentUser.name } />
                    <div className='username'>{ this.props.currentUser.name }</div>
                </div>
            </div>

            <div className='left' onClick={ this._handleChatToggle }>
                <div className='expand-chat left'>
                    <i className='material-icons'>keyboard_arrow_right</i>
                </div>
                <div className='lobby-name'>{ this.props.lobby.name }</div>
            </div>

            <div className='center'>
                <div className='branded'>
                    Bad Decisions
                </div>
            </div>
        </div>

        { newGame }
        { joinGame }

        { playerList }
        { round }
        { playerHands }
        { children }
    </div>`
