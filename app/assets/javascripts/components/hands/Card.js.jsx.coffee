@Card = React.createClass
  propTypes:
    card: React.PropTypes.object.isRequired


  render: ->
    `<div className='game-card-noform'>
        <div className='card-data'>{ JSON.stringify(this.props.card) }</div>
    </div>`
