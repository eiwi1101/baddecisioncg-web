@Aside = React.createClass
  render: ->
    `<aside>
        <AsideTabs/>

        <Chat lobby={this.props.lobby} />
        <UserList lobby={this.props.lobby} lobby_user={this.props.lobby_user} />
        <Settings lobby={this.props.lobby} />

        <ChatForm lobby={this.props.lobby} lobby_user={this.props.lobby_user} />
    </aside>`
