@PlayerHand = (props) ->
  `<div className='bottom-panel'>
      <Tabs>
          <Tab target='#fool-hand'>Fool</Tab>
          <Tab target='#crisis-hand'>Crisis</Tab>
          <Tab target='#decision-hand'>Decision</Tab>
      </Tabs>

      <CardList cards={props.foolHand} id='fool-hand' size='s6 m3 l2' />
      <CardList cards={props.crisisHand} id='crisis-hand' size='s6 m3 l2' />
      <CardList cards={props.badDecisionHand} id='decision-hand' size='s6 m3 l2' />
  </div>`
