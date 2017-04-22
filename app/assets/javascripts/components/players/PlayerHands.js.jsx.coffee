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
      .on 'player', (player) =>
        console.log "LobbyUserChannel.on cards: ", player.player_cards
        console.log "Player: #{JSON.stringify(player)}"
        @setState cards: player.player_cards if player.player_cards


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
        <Hand id='fool-hand' cards={ hand.fool } />
        <Hand id='crisis-hand' cards={ hand.crisis } />
        <Hand id='decision-hand' cards={ hand.bad_decision } />

        <div id='player-cards' className='debug-data'>Cards: { JSON.stringify(this.state.cards) }</div>
    </div>`
