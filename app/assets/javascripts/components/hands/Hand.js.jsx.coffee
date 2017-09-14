@Hand = React.createClass
  propTypes:
    id: React.PropTypes.string.isRequired
    cards: React.PropTypes.array
    isRound: React.PropTypes.bool
    active: React.PropTypes.bool


  getInitialState: ->
    active: !!@props.active
    activeCardIndex: 0

  _initialize: ->
    $hand = $(@refs.hand)
    $cards = $hand.children('.card-container')

    handWidth = $hand.outerWidth()
    cardWidth = $cards.outerWidth()

    if !@state.active
      cardWidth *= 0.6

    cardOffset = (handWidth - cardWidth) / ($cards.length - 1)
    cardMiddle = ($cards.length - 1) / 2

    for card, i in $cards
      centerOffsetIndex = i - cardMiddle
      centerActiveOffsetIndex = i - @state.activeCardIndex

      $card = $(card)
      rot = 5 * centerOffsetIndex # deg
      shift_y = -20 * Math.pow(2, Math.abs(centerOffsetIndex)) # px
      shift_x = -20 * centerOffsetIndex
      z_index = 20 - Math.abs centerActiveOffsetIndex

      if !@state.active
        zoom = 0.6
      else
        zoom = 0.9

      $card.css
        left: cardOffset * i + shift_x
        bottom: shift_y
        transform: "rotate(#{rot}deg) scale(#{zoom})"
        zIndex: z_index


  componentDidMount: ->
    $(window).resize @_initialize
    @_initialize()

    $(@refs.handControl)
      .click =>
        @setState active: !@state.active

    $(@refs.handActivate)
      .click =>
        @setState active: true

  componentDidUpdate: ->
    @_initialize()

  componentWillUnmount: ->
    $(window).off 'resize', @_initialize


  _handleCardActive: (index) ->
    # SoundEffect.play 'cardHover' if index isnt @state.index
    @setState activeCardIndex: index


  render: ->
    classNames = ['card-hand']
    classNames.push 'active' if @state.active
    display = if @state.active then 'none' else 'block'

    cards = @props.cards.map (card, i) =>
      isRound = @props?.isRound
      `<Card key={ card.id } card={ card } isRound={ isRound } index={ i } onActive={ _this._handleCardActive } />`

    `<div ref='hand' className={ classNames.join(' ') } id={ this.props.id }>
        { cards }

        { this.props.type &&
            <div ref='handControl' className='hand-control'>
                { this.props.type }
            </div>
        }

        <div ref='handActivate' className='hand-activate' style={{ display: display }} />
    </div>`
