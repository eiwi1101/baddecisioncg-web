@Round = React.createClass
  propTypes:
    game: React.PropTypes.object.isRequired
    round: React.PropTypes.object


  getInitialState: ->
    round: @props.round
    story: @props.round?.story
    playerCards: @props.round?.player_cards


  componentWillMount: ->
    if !@state.round? && @props.game? && @props.game.current_round_id?
      Model.fetch "/rounds/#{@props.game.current_round_id}.json", (round) =>
        @setState round: round, story: round.story, playerCards: round.player_cards


  _handleNewRound: (e) ->
    Model.post "#{@props.game.path}/rounds.json", (round) ->
      @setState round: round, story: round.story, playerCards: round.player_cards
    e.preventDefault()


  render: ->
    if @state.round?
      story =
        `<div>Story: { JSON.stringify(this.state.story) }</div>`

      playerCards =
        `<div>Player Cards: { JSON.stringify(this.state.playerCards) }</div>`

    else if @props.game.isReady
      newRound =
        `<a href='#' onClick={ this._handleNewRound }>New Round</a>`

    `<div className='round-container'>
        <div>Round: { JSON.stringify(this.state.round) }</div>

        { story }
        { playerCards }

        { newRound }
    </div>`
