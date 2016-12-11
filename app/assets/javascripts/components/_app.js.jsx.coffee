@App = React.createClass

  componentDidMount: ->
    LobbyChannel.subscribe(this.props.lobby.token, this.props.lobby_user.guid)

  render: ->
    `<div id='game-area'>
        <Aside lobby={this.props.lobby} lobby_user={this.props.lobby_user} />
    </div>`
