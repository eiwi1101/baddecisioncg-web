@WaitingScreen = React.createClass
  render: ->
    if this.props.joined
      message = 'You have joined the game.'
      button = `<a href='#' onClick={this.props.onStart} className='btn red'>Start Game</a>`
    else
      message = 'A game is starting soon. Want in?'
      button = `<a href='#' onClick={this.props.onJoin} className='btn'>Join Game</a>`
      
    `<div className='waiting-screen center'>
        <div className='caption margin-bottom-lg'>{ message }</div>
        { button }
    </div>`
