@Round = React.createClass
  propTypes:
    game: React.PropTypes.object.isRequired
    round: React.PropTypes.object
    onChange: React.PropTypes.func


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
        @setState round: round, story: round.story, playerCards: round.player_cards


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

      playerCards =
        `<Hand id='round-player-cards' cards={ this.state.playerCards } />`

    else if @props.game.isReady
      startGame =
        `<a href='#' onClick={ this._handleNewRound }>Start Game</a>`

    `<div className='round-container'>
        <div id='round-data'>Round: { JSON.stringify(this.state.round) }</div>

        { story }
        { playerCards }

        { startGame }
    </div>`
