@PlayerHands = React.createClass
  propTypes:
    currentUser: React.PropTypes.object.isRequired
    currentPlayer: React.PropTypes.object.isRequired
    cards: React.PropTypes.array


  getInitialState: ->
    cards: @props.cards || []


  componentWillMount: ->
    if !@props.cards and @props.currentPlayer
      Model.fetch "/players/#{@props.currentPlayer.id}/cards.json", (cards) =>
        @setState cards: cards

    LobbyUserChannel
      .on 'cards', (cards) =>
        console.log "LobbyUserChannel.on cards: ", cards
        @setState cards: cards


  render: ->
    hand = {
      fool: []
      crisis: []
      bad_decision: []
    }

    for card in @state.cards
      hand[card.type] = [] unless hand[card.type]
      hand[card.type].push card

    `<div className='player-hands'>
        <div id='player-cards'>Cards: { JSON.stringify(this.state.cards) }</div>

        <Hand id='fool-hand' cards={ hand.fool } />
        <Hand id='crisis-hand' cards={ hand.crisis } />
        <Hand id='decision-hand' cards={ hand.bad_decision } />
    </div>`
