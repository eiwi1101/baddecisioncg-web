@Hand = React.createClass
  propTypes:
    id: React.PropTypes.string.isRequired
    cards: React.PropTypes.array


  render: ->
    cards = @props.cards.map (card) ->
      `<Card key={ card.id } card={ card } />`

    `<div className='card-hand' id={ this.props.id }>
        { cards }
    </div>`
