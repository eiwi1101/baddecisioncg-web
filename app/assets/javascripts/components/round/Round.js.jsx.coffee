@Round = React.createClass
  propTypes:
    game: React.PropTypes.object.isRequired
    round: React.PropTypes.object
    onChange: React.PropTypes.func
    currentPlayer: React.PropTypes.object


  getInitialState: ->
    round: @props.round
    story: @props.round?.story
    playerCards: @props.round?.player_cards


  load: ->
    Model.fetch "/rounds/#{@props.game.current_round_id}.json", (round) =>
      @setState round: round, story: round.story, playerCards: round.player_cards
      @props.onChange round if @props.onChange

  componentWillMount: ->
    if !@props.round && @props.game? && @props.game.current_round_id?
      @load()

    LobbyChannel
      .on 'round', (round) =>
        unless round.status == 'setup' and @context.currentPlayer?.is_bard
          @setState round: round, story: round.story, playerCards: round.player_cards

    LobbyUserChannel
      .on 'player', (player) =>
        if player.bard_setup and @state.round
          round = @state.round
          round.fool = player.bard_setup.fool_pc
          round.crisis = player.bard_setup.crisis_pc
          round.bad_decision = player.bard_setup.bad_decision_pc
          @setState round: round


  _handleNewRound: (e) ->
    Model.post "#{@props.game.path}/rounds.json", {}, (round) =>
      @setState round: round, story: round.story, playerCards: round.player_cards
    e.preventDefault()


  render: ->
    if @state.round?
      story =
        `<Story id='round-story'
                card={ this.state.story }
                fool={ this.state.round.fool }
                crisis={ this.state.round.crisis }
                badDecision={ this.state.round.bad_decision }
        />`

      statusBar =
        `<div className='status-bar round-status'>
            <div className='right'>
                <div className='status-data'>
                    <div className='label'>Round:</div>
                    <div className='value'>{ this.state.round.id }</div>
                </div>

                <div className='status-data'>
                    <div className='label'>Status:</div>
                    <div className='value'>{ this.state.round.status }</div>
                </div>
            </div>
        </div>`

      if @state.round.status == 'bard_pick'
        playerCards =
          `<Hand id='round-player-cards' cards={ this.state.playerCards } isRound />`

      else if @state.round.status == 'player_pick'
        playerCards =
          `<div>PILE!</div>`

      if @state.round.status == 'finished'
        nextRound =
          `<a href='#' className='action-button' onClick={ this._handleNewRound }>Next Round</a>`

    else if @props.game.isReady and @props.currentPlayer
      nextRound =
        `<a href='#' className='action-button' onClick={ this._handleNewRound }>Start Game</a>`


    `<div className='round-container'>
        <div id='round-data' className='debug-data'>Round: { JSON.stringify(this.state.round) }</div>

        { statusBar }

        { story }
        { playerCards }

        { nextRound }
    </div>`
