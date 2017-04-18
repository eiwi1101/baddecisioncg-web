@PlayerHands = React.createClass
  propTypes:
    currentUser: React.PropTypes.object.isRequired
    currentPlayer: React.PropTypes.object.isRequired
    cards: React.PropTypes.object


  getInitialState: ->
    cards: @props.cards


  componentWillMount: ->
    if !@props.cards
      Model.fetch "/players/#{@props.currentPlayer.id}/cards.json", (cards) =>
        @setState cards: cards

    LobbyUserChannel
      .on 'cards', (cards) =>
        console.log "LobbyUserChannel.on cards: ", cards
        @setState cards: cards


  render: ->
    `<div className='player-hands'>
        <div id='player-cards'>Cards: { JSON.stringify(this.state.cards) }</div>
    </div>`
