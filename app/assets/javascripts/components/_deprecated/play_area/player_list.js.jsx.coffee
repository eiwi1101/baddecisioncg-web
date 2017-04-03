@PlayerList = React.createClass
  render: ->
    players = []
    for key, player of @props.players
      continue if player.is_deleted
      
      className = 'chip'
      badgeClass = 'badge new transparent'

      if key == @props.bard_guid
        className += ' teal lighten-1 white-text'
        badgeClass += ' teax-text text-lighten-5'
      else
        badgeClass += ' grey-text'
      
      players.push(
        `<div className={className} key={key}>
            <img src={player.avatar_url} alt={player.name} />
            { player.name }
            <span className={badgeClass} data-badge-caption='points'>{ player.score }</span>
        </div>`
      )

    `<div className='player-list'>
        { players }
    </div>`
