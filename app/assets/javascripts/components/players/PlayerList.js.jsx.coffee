@PlayerList = React.createClass
  propTypes:
    players: React.PropTypes.array.isRequired
    currentPlayer: React.PropTypes.object


  _initialize: ->
    $list = $(@refs.playerList)
    $players = $list.children '.player'

    console.log "Arranging #{$players.length} players..."

    width = $list.width()
    height = $list.height()
    radius = Math.min(width, height) / 2

    console.log "Width: #{width}, height: #{height}, radius: #{radius}"

    angle = 0
    step = (2*Math.PI) / @props.players.length

    $players.each ->
      x = Math.round(width / 2 + radius * Math.cos(angle))
      y = Math.round(height / 2 + radius * Math.sin(angle))
      angle += step

      console.log "Placing card at (#{x},#{y})..."
      $(this).animate
        left: x
        top: y


  componentDidMount: ->
    @_initialize()

  componentDidUpdate: ->
    @_initialize()

  render: ->
    if @props.players? and @props.players.length
      players = @props.players?.map (player) =>
        `<Player key={ player.id } player={ player } current={ player.id == _this.props.currentPlayer } />`

    `<div ref='playerList' className='player-list players-container'>
        <div id='game-players' className='debug-data'>Players: { JSON.stringify(this.props.players) }</div>
        <div id='current-player' className='debug-data'>Current Player: { JSON.stringify(this.props.currentPlayer) }</div>

        { players }
    </div>`
