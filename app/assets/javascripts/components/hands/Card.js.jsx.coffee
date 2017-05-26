@Card = React.createClass
  contextTypes:
    currentGame: React.PropTypes.object

  propTypes:
    card: React.PropTypes.object.isRequired
    isRound: React.PropTypes.bool
    index: React.PropTypes.number
    onActive: React.PropTypes.func
    style: React.PropTypes.object


  componentDidMount: ->
    $(@refs.card)
      .mouseover =>
        @props.onActive(@props.index) if @props.onActive


  _handlePlay: (e) ->
    console.log "Play Card: ", @context.currentGame.current_round_id

    if @props.isRound
      endpoint = 'winner'
    else
      endpoint = 'cards'

    if @context.currentGame?.current_round_id
      Model.post "/rounds/#{this.context.currentGame.current_round_id}/#{endpoint}.json", card_id: @props.card.id

    e.preventDefault()


  render: ->
    classNames = ['game-card']

    if @props.card.text
      classNames.push "card-#{Util.typeClasses[@props.card.type]}"
    else
      classNames.push 'card-back'
      classNames.push "card-back-#{Util.typeClasses[@props.card.type]}"

    `<a href='#' ref='card' onClick={ this._handlePlay } data-index={ this.props.index } id={ 'card-' + this.props.card.id } className='card-container'>
        <div className={ classNames.join(' ') } style={ this.props.style }>
            { this.props.card.text }
        </div>

        <div className='debug-data card-data'>{ JSON.stringify(this.props.card) }</div>
    </a>`
