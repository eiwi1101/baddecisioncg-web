@Card = React.createClass
  contextTypes:
    currentRound: React.PropTypes.object

  propTypes:
    card: React.PropTypes.object.isRequired


  _handlePlay: (e) ->
    console.log "Play Card: ", @context.currentRound
    if @context.currentRound
      Model.post "/rounds/#{this.context.currentRound.id}/cards.json", card_id: @props.card.id
    e.preventDefault()


  render: ->
    `<div className='game-card-noform' id={ 'card-' + this.props.card.id }>
        <div className='card-data'>{ JSON.stringify(this.props.card) }</div>
        <a href='#' onClick={ this._handlePlay }>Play</a>
    </div>`
