@PlayerList = React.createClass
  propTypes:
    players: React.PropTypes.array.isRequired
    currentPlayer: React.PropTypes.object


  render: ->
    if @props.players? and @props.players.length
      players = @props.players?.map (player) ->
        `<Player key={ player.id } player={ player } />`

    `<div className='players-container'>
        <div>Players: { JSON.stringify(this.props.players) }</div>
        <div>Current Player: { JSON.stringify(this.props.currentPlayer) }</div>

        { players }
    </div>`
