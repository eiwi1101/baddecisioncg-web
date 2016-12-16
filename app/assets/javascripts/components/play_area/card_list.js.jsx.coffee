@CardList = (props) ->
  cards = []
  
  for key, card of props.cards
    cards.push `<Card key={key} size={props.size} {...card} />`
    
  `<div id={props.id} className='row masonry content'>
    { cards }
  </div>`
