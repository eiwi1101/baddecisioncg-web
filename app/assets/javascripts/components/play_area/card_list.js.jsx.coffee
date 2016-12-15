@CardList = (props) ->
  cards = []
  
  for key, card of props.cards
    next unless card.is_in_hand
    cards << `<Card key={key} {...card} />`
    
  `<div id={props.id} className='row masonry'>
    { cards }
  </div>`
