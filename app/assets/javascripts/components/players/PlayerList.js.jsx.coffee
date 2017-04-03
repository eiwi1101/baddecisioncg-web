@PlayerList = React.createClass
  propTypes:
    players: React.PropTypes.array.isRequired


  render: ->
    if @props.players? and @props.players.length
      players = @props.players?.map (player) ->
        `<Player player={ player } />`

    `<div className='players-container'>
        { players }
    </div>`
