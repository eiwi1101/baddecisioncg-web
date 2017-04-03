@Player = React.createClass
  propTypes:
    player: React.PropTypes.object.isRequired


  render: ->
    `<div className='player'>
        Player: { this.props.player }
    </div>`
