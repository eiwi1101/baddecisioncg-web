@PlayerList = React.createClass
  render: ->
    players = @props.players.map (player) ->
      `<div className='chip' key={player.guid}>
          <img src={player.avatar_url} alt={player.name} />
          { player.name }
          <span className='badge new' data-badge-caption='points'>{ player.score }</span>
      </div>`

    `<div className='player-list'>
        { players }
    </div>`
