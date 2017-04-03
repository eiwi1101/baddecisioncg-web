@PlayerList = React.createClass
  propTypes:
    game: React.PropTypes.object.isRequired
    players: React.PropTypes.object.isRequired


  render: ->
    players = @props.players?.map (player) ->
      `<Player player={ player } />`

    `<div className='players-container'>
        { players }
    </div>`
