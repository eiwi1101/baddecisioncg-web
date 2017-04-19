@Hand = React.createClass
  propTypes:
    id: React.PropTypes.string.isRequired
    cards: React.PropTypes.array
    isRound: React.PropTypes.bool


  render: ->
    cards = @props.cards.map (card) =>
      isRound = @props?.isRound
      `<Card key={ card.id } card={ card } isRound={ isRound } />`

    `<div className='card-hand' id={ this.props.id }>
        { cards }
    </div>`
