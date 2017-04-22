@Card = React.createClass
  contextTypes:
    currentRound: React.PropTypes.object

  propTypes:
    card: React.PropTypes.object.isRequired
    isRound: React.PropTypes.bool


  _handlePlay: (e) ->
    console.log "Play Card: ", @context.currentRound

    if @props.isRound
      endpoint = 'winner'
    else
      endpoint = 'cards'

    if @context.currentRound
      Model.post "/rounds/#{this.context.currentRound.id}/#{endpoint}.json", card_id: @props.card.id

    e.preventDefault()


  render: ->
    classNames = ['game-card']
    classNames.push "card-#{Util.typeClasses[@props.card.type]}"

    `<a href='#' onClick={ this._handlePlay } id={ 'card-' + this.props.card.id } className='card-container'>
        <div className={ classNames.join(' ') }>
            { this.props.card.text }
        </div>

        <div className='debug-data card-data'>{ JSON.stringify(this.props.card) }</div>
    </a>`
