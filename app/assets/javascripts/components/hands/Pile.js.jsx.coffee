@Pile = (props) ->
  cards = []

  width = $('.round-container').width()
  height = $('.round-container').height()

  props.cards.map (card) ->
    x = parseInt("0x#{card.id[0..1]}")
    y = parseInt("0x#{card.id[2..3]}")
    z = parseInt("0x#{card.id[4..5]}")

    left = (x / 255) * (width/2)
    top = (y / 255) * (height/2)

    left += 150 if left > 0
    left -= 150 if left < 0

    transform = "rotate(#{(z / 255 * 360)}deg)"

    cards.push(
      `<Card card={ card } key={ card.id } style={{ left: left, top: top, transform: transform }} />`
    )

  `<div className='card-pile'>
      { cards }
  </div>`
