@Story = React.createClass
  propTypes:
    id: React.PropTypes.string
    card: React.PropTypes.object.isRequired
    fool: React.PropTypes.object
    crisis: React.PropTypes.object
    badDecision: React.PropTypes.object


  render: ->
    `<div className='game-card-nores story-card' id={ this.props.id }>
        <div id='story-data'>{ JSON.stringify(this.props.card) }</div>
        <div id='fool-blank'>{ JSON.stringify(this.props.fool) }</div>
        <div id='crisis-blank'>{ JSON.stringify(this.props.crisis) }</div>
        <div id='bad-decision-blank'>{ JSON.stringify(this.props.badDecision) }</div>
    </div>`
