@Round = React.createClass
  propTypes:
    game: React.PropTypes.object.isRequired
    round: React.PropTypes.object


  getInitialState: ->
    round: @props.round
    story: @props.round?.story
    playerCards: @props.round?.player_cards


  componentWillMount: ->
    if !@state.round? && @state.game? && @props.game.current_round_id?
      Model.fetch "/rounds/#{current_round_id}.json", (round) =>
        @setState round: round, story: round.story, playerCards: round.player_cards


  render: ->
    `<div className='round-container'>
        <div>Round: { JSON.stringify(this.state.currentRound) }</div>
        <div>Story: { this.state.story }</div>
        <div>Player Cards: { this.state.playerCards }</div>
    </div>`
