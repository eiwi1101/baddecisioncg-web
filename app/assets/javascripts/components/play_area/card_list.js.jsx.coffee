@CardList = (props) ->
  cards = []
  
  for key, card of props.cards
    cards.push `<Card key={key} onPlay={props.onPlay} size={props.size} {...card} />`
    
  `<div id={props.id} className='row masonry content'>
    { props.children || cards }
  </div>`
