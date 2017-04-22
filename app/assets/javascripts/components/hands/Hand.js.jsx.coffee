@Hand = React.createClass
  propTypes:
    id: React.PropTypes.string.isRequired
    cards: React.PropTypes.array
    isRound: React.PropTypes.bool


  _initialize: ->
    $hand = $(@refs.hand)
    $cards = $hand.children('.card-container')

    handWidth = $hand.outerWidth()
    cardWidth = $cards.outerWidth()
    cardOffset = (handWidth - cardWidth) / ($cards.length - 1)
    cardMiddle = ($cards.length - 1) / 2

    for card, i in $cards
      centerOffsetIndex = i - cardMiddle

      $card = $(card)
      rot = 5 * centerOffsetIndex # deg
      shift_y = -20 * Math.pow(2, Math.abs(centerOffsetIndex)) # px
      shift_x = -20 * centerOffsetIndex

      $card.css
        left: cardOffset * i + shift_x
        bottom: shift_y
        transform: "rotate(#{rot}deg)"


  componentDidMount: ->
    @_initialize()
    $(window).resize @_initialize

  componentDidUpdate: ->
    @_initialize()

  componentWillUnmount: ->
    $(window).off 'resize', @_initialize


  render: ->
    cards = @props.cards.map (card) =>
      isRound = @props?.isRound
      `<Card key={ card.id } card={ card } isRound={ isRound } />`

    `<div ref='hand' className='card-hand' id={ this.props.id }>
        { cards }
    </div>`
