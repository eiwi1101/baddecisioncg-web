@PlayerHand = React.createClass
  getInitialState: ->
    fool: @props.foolHand || {}
    crisis: @props.crisisHand || {}
    bad_decision: @props.badDecisionHand || {}
    
  componentDidMount: ->
    LobbyUserChannel.subscribe { lobby_user_id: @props.lobbyUserGuid },
      player: (player) ->
        if player.cards
          player.cards.map (card) ->
            console.log card
            if (card.is_discarded) delete @state[card.type][card.guid]
            else @state[card.type][card.guid] = card

      connect: ->
        console.log 'Tell me your sweet, sweet secrets...'
    
  render: ->
    `<div className='bottom-panel'>
        <Tabs>
            <Tab target='#fool-hand'>Fool</Tab>
            <Tab target='#crisis-hand'>Crisis</Tab>
            <Tab target='#decision-hand'>Decision</Tab>
        </Tabs>
        
        <CardList cards={this.state.fool} id='fool-hand' />
        <CardList cards={this.state.crisis} id='crisis-hand' />
        <CardList cards={this.state.bad_decision} id='decision-hand' />
    </div>`
