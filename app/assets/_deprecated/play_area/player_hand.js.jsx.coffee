@PlayerHand = React.createClass
  playCard: (guid) ->
    $.post @props.playUrl, player_card_id: guid

  render: ->
    `<div className='bottom-panel'>
        <Tabs>
            <Tab target='#fool-hand'>Fool</Tab>
            <Tab target='#crisis-hand'>Crisis</Tab>
            <Tab target='#decision-hand'>Decision</Tab>
        </Tabs>

        <CardList cards={this.props.foolHand} id='fool-hand' size='s6 m3 l2' onPlay={this.playCard} />
        <CardList cards={this.props.crisisHand} id='crisis-hand' size='s6 m3 l2' onPlay={this.playCard} />
        <CardList cards={this.props.badDecisionHand} id='decision-hand' size='s6 m3 l2' onPlay={this.playCard} />
    </div>`
