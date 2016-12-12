@App = React.createClass

  componentWillMount: ->
    console.log 'Initializing the application!'

  componentDidMount: ->
    LobbyChannel.subscribe(this.props.lobby.token, this.props.lobby_user.guid)

  render: ->
    `<div id='game-area'>
        <PlayArea lobby={this.props.lobby} lobby_user={this.props.lobby_user} game={this.props.game} />
        <Aside lobby={this.props.lobby} lobby_user={this.props.lobby_user} />
    </div>`
