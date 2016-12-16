@StatusBar = (props) ->
  `<div className='status-bar'>
      Round: { props.round && props.round.status } |
      Status: { props.game.status } |
      Score Limit: { props.game.score_limit } |
      Round: 0
  </div>`
