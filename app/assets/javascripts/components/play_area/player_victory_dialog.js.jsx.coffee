@PlayerVictoryDialog = (props) ->
  `<div className='wait-screen next-round'>
      <p className='caption'>{ props.player.name } wins the round!</p>
      <a href='#' className='btn btn-sm' onClick={props.onConfirm}>Next Round</a>
  </div>`
