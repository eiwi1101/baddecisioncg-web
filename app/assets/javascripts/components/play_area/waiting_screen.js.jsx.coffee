@WaitingScreen = (props) ->
  if props.joined
    if !props.ready
      message = 'Waiting for more players...'
      button = `<a href='#' onClick={props.onStart} className='btn red lighten-2'>Waiting...</a>`
    else
      message = 'Ready to start?'
      button = `<a href='#' onClick={props.onStart} className='btn red'>Start Game</a>`
  else
    message = 'A game is starting soon. Want in?'
    button = `<a href='#' onClick={props.onJoin} className='btn'>Join Game</a>`

  `<div className='waiting-screen center'>
      <div className='caption margin-bottom-lg'>{ message }</div>
      { button }
  </div>`
