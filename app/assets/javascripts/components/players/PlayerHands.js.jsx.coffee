
@PlayerHands = React.createClass
  propTypes:
    currentUser: React.PropTypes.object.isRequired
    cards: React.PropTypes.object


  getInitialState: ->
    cards: @props.cards


  render: ->
    `<div className='player-hands'>
        <div id='player-cards'>Cards: { JSON.stringify(this.state.cards) }</div>
    </div>`
