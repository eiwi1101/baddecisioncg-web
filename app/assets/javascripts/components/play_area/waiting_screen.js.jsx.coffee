@WaitingScreen = React.createClass
  render: ->
    if this.props.joined
      button = `<a href='#' onClick={this.props.onStart} className='btn red'>Start Game</a>`
    else
      button = `<a href='#' onClick={this.props.onJoin} className='btn'>Join Game</a>`
      
    `<div className='waiting-screen center'>
        <div className='caption margin-bottom-lg'>A game is starting soon!</div>
        { button }
    </div>`
