@PlayerHands = React.createClass
  propTypes:
    currentUser: React.PropTypes.object.isRequired
    cards: React.PropTypes.object


  getInitialState: ->
    cards: @props.cards


  render: ->
    `<div className='player-hands'>
        Cards: { JSON.stringify(this.state.cards) }
    </div>`
