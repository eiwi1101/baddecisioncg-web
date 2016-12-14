@StatusBar = (props) ->
  `<div className='status-bar'>
      Status: { props.game.status } |
      Score Limit: { props.game.score_limit } |
      Round: 0
  </div>`
