@Player = React.createClass
  propTypes:
    player: React.PropTypes.object.isRequired
    current: React.PropTypes.bool


  render: ->
    classNames = ['player']
    classNames.push 'bard' if @props.player.is_bard
    classNames.push 'current' if @props.current

    `<div className={ classNames.join(' ') }>
        <div className='debug-data'>{ JSON.stringify(this.props.player) }</div>
        <div className='player-score'>{ this.props.player.score }</div>
        <img src={ this.props.player.avatar_url } className='avatar circle z-depth-2' alt={ this.props.player.name } />
        <div className='player-name'>{ this.props.player.name }</div>
    </div>`
