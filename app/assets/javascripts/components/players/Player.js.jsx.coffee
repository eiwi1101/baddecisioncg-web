@Player = React.createClass
  propTypes:
    player: React.PropTypes.object.isRequired


  render: ->
    `<div className='player'>
        Player: { JSON.stringify(this.props.player) }
    </div>`
